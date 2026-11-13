import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/service/separacao_adicionar_item_service.dart';
import 'package:app_expedicao/src/service/conferencia_adicionar_item_service.dart';

import 'app_socket_recovery_test.dart' show MemorySocket;
import 'two_collectors_recovery_test.dart' show ServerFixture;

void main() {
  late MemorySocket socket;
  late AppSocketConfig config;
  var reloads = 0;
  setUp(() {
    Get.testMode = true;
    socket = MemorySocket();
    config = AppSocketConfig(socketFactory: (_, _) => socket);
    config.initSocket();
    Get.put(config);
    Get.put(
      ProcessoExecutavelModel.empty().copyWith(
        codUsuario: 7,
        nomeUsuario: 'Teste',
      ),
    );
    socket.onconnect('operation-test', null);
    reloads = 0;
    config.recovery.register('documento', () async {
      reloads++;
    });
    socket.respond = (body) =>
        socket.reply(body, {'Mutation': body['Mutation']});
  });
  tearDown(() {
    Get.reset();
  });

  Future<List<Map<String, dynamic>>> write([
    Object input = const {'Item': '1'},
  ]) => config.mutateMapped(
    eventSuffix: 'separacao.item.update',
    mutation: input,
    fromJson: (json) => json,
  );

  test('falha de negócio após primeiro commit bloqueia repetição e consulta estado', () async {
    var calls = 0;
    socket.respond = (body) {
      calls++;
      socket.reply(
        body,
        calls == 1
            ? {'Mutation': body['Mutation']}
            : {
                'Error': ['[50014] Estágio recusado.'],
              },
      );
    };
    await expectLater(
      config.mutationOperation.run(() async {
        await write();
        await write();
        await write();
      }),
      throwsA(isA<AppError>()),
    );
    expect(calls, 2);
    expect(config.recovery.blocksMutation, isTrue);
    await expectLater(
      config.mutationOperation.run(write),
      throwsA(isA<AppError>()),
    );
    expect(reloads, 1);
    expect(calls, 2);
  });

  test(
    'recusa antes do primeiro commit não cria pendência de gravação',
    () async {
      socket.respond = (body) => socket.reply(body, {
        'Error': ['[50014] Recusado.'],
      });
      await expectLater(
        config.mutationOperation.run(write),
        throwsA(isA<AppError>()),
      );
      expect(config.recovery.blocksMutation, isFalse);
    },
  );

  test(
    'falha em operação aninhada mantém commits anteriores da ação externa',
    () async {
      await expectLater(
        config.mutationOperation.run(() async {
          await config.mutationOperation.run(write);
          await config.mutationOperation.run<void>(() async {
            throw AppError('Consulta falhou');
          });
        }),
        throwsA(isA<AppError>()),
      );
      expect(config.recovery.needsRefresh, isTrue);
      expect(socket.sent, hasLength(1));
    },
  );

  test('sucesso e lote vazio não deixam pendência', () async {
    await config.mutationOperation.run(() async {
      await write();
      await write([]);
    });
    expect(config.recovery.blocksMutation, isFalse);
  });

  for (final returned in [0, 1, 3]) {
    test(
      'lote de dois com $returned confirmações é rejeitado sem repetir',
      () async {
        socket.respond = (body) => socket.reply(body, {
          'Mutation': List.generate(returned, (i) => {'Item': '$i'}),
        });
        await expectLater(
          write([
            {'Item': '1'},
            {'Item': '2'},
          ]),
          throwsA(isA<AppError>()),
        );
        expect(config.recovery.needsRefresh, isTrue);
        expect(socket.sent, hasLength(1));
      },
    );
  }

  test(
    'outra ação e mutação avulsa não se intercalam com ação pendente',
    () async {
      final started = Completer<void>();
      final release = Completer<void>();
      final pending = config.mutationOperation.run(() async {
        await write();
        started.complete();
        await release.future;
        await write();
      });
      await started.future;
      await expectLater(
        config.mutationOperation.run(write),
        throwsA(isA<AppError>()),
      );
      await expectLater(write(), throwsA(isA<AppError>()));
      expect(socket.sent, hasLength(1));
      release.complete();
      await pending;
      expect(socket.sent, hasLength(2));
      expect(config.recovery.blocksMutation, isFalse);
    },
  );

  for (final conferencia in [false, true]) {
    test(
      '${conferencia ? 'conferência' : 'separação'}: consulta de lote com uma linha faltante exige recarga',
      () async {
        final stage = ExpedicaoCarrinhoPercursoEstagioConsultaModel(
          codEmpresa: 1,
          codCarrinhoPercurso: 100,
          item: '1',
          codPercursoEstagio: 8,
          origem: conferencia ? 'CO' : 'SE',
          codOrigem: 10,
          situacao: 'SEPARANDO',
          carrinhoAgrupador: 'N',
          codCarrinho: 94,
          nomeCarrinho: 'Teste',
          codigoBarrasCarrinho: '94',
          ativo: 'S',
          codUsuarioInicio: 7,
          nomeUsuarioInicio: 'Teste',
          dataInicio: DateTime(2026, 11, 13),
          horaInicio: '10:00:00',
        );
        final fixture = ServerFixture(
          conferencia ? 'conferencia.item' : 'separacao.item',
        );
        final pedidos = [
          for (var i = 1; i <= 2; i++)
            {
              ...fixture.makeRow(i, 1, 'operation-test'),
              'CodProduto': i,
              'Origem': 'SE',
              'CodOrigem': 10,
              'ItemOrigem': '$i',
              'CodSetorEstoque': 1,
              'CodLocalArmazenagem': 1,
              'QuantidadeSeparacao': '0',
              'QuantidadeConferida': '0',
              'QuantidadeInterna': '0',
              'QuantidadeExterna': '0',
              'SituacaoCarrinhoPercurso': 'CONFERINDO',
              'NomeSetorEstoque': '',
              'CodMarca': 1,
              'NomeMarca': '',
              'CodigoBarras': '$i',
              'CodigoBarras2': '',
              'CodigoReferencia': '',
              'CodigoFornecedor': '',
              'CodigoFabricante': '',
              'CodigoOriginal': '',
              'Endereco': '',
              'EnderecoDescricao': '',
            },
        ];
        socket.respond = (body) {
          final event = socket.sent.last['event'] as String;
          if (body.containsKey('Mutation')) {
            final inputs = body['Mutation'] as List;
            expect(inputs, hasLength(2));
            socket.reply(body, {
              'Mutation': [
                for (var i = 0; i < inputs.length; i++)
                  {...inputs[i] as Map, 'Item': '${i + 1}'},
              ],
            });
          } else if (event.endsWith('separar.item.select') ||
              event.endsWith('conferir.item.consulta')) {
            socket.reply(body, {'Data': pedidos});
          } else if (event.endsWith('.select')) {
            socket.reply(body, {'Data': []});
          } else {
            socket.reply(body, {
              'Data': [fixture.makeRow(1, 1, 'operation-test')],
            });
          }
        };
        final action = conferencia
            ? ConferenciaAdicionarItemService(percursoEstagioConsulta: stage)
                  .addAll()
            : SeparacaoAdicionarItemService(percursoEstagioConsulta: stage)
                  .addAll();
        await expectLater(action, throwsA(isA<AppError>()));
        expect(
          socket.sent.where((e) => e.containsKey('Mutation')),
          hasLength(1),
        );
        expect(config.recovery.needsRefresh, isTrue);
      },
    );

    for (final readError in [false, true]) {
      test(
        '${conferencia ? 'conferência' : 'separação'}: commit seguido de ${readError ? 'erro' : 'consulta vazia'} exige recarga',
        () async {
          final stage = ExpedicaoCarrinhoPercursoEstagioConsultaModel(
            codEmpresa: 1,
            codCarrinhoPercurso: 31,
            item: '3',
            codPercursoEstagio: 8,
            origem: conferencia ? 'CO' : 'SE',
            codOrigem: 71,
            situacao: 'SEPARANDO',
            carrinhoAgrupador: 'N',
            codCarrinho: 4,
            nomeCarrinho: 'Teste',
            codigoBarrasCarrinho: '4',
            ativo: 'S',
            codUsuarioInicio: 7,
            nomeUsuarioInicio: 'Teste',
            dataInicio: DateTime(2026, 11, 13),
            horaInicio: '10:00:00',
          );
          socket.respond = (body) {
            if (body.containsKey('Mutation')) {
              socket.reply(body, {
                'Mutation': {...body['Mutation'] as Map, 'Item': '1'},
              });
            } else {
              socket.reply(
                body,
                readError
                    ? {
                        'Error': ['[SQL-CONN] Consulta falhou.'],
                      }
                    : {'Data': []},
              );
            }
          };
          final action = conferencia
              ? ConferenciaAdicionarItemService(percursoEstagioConsulta: stage)
                    .add(codProduto: 5, codUnidadeMedida: 'UN', quantidade: 1)
              : SeparacaoAdicionarItemService(percursoEstagioConsulta: stage)
                    .add(codProduto: 5, codUnidadeMedida: 'UN', quantidade: 1);
          await expectLater(action, throwsA(isA<AppError>()));
          expect(config.recovery.needsRefresh, isTrue);
          expect(
            socket.sent.where((e) => e.containsKey('Mutation')),
            hasLength(1),
          );
        },
      );
    }
  }
}
