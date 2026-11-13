import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_adicionar_service.dart';
import 'package:app_expedicao/src/service/conferir_consultas_services.dart';
import 'package:app_expedicao/src/service/separar_consultas_services.dart';
import 'package:app_expedicao/src/service/expedicao_percurso_atualizar_service.dart';

import '../app/app_socket_recovery_test.dart' show MemorySocket;

void main() {
  late MemorySocket socket;
  late AppSocketConfig config;
  final percurso = ExpedicaoCarrinhoPercursoModel(
    codEmpresa: 1,
    codCarrinhoPercurso: 31,
    origem: 'SE',
    codOrigem: 71,
    situacao: 'SEPARANDO',
    dataInicio: DateTime(2026, 11, 13),
    horaInicio: '10:00:00',
  );

  setUp(() {
    Get.testMode = true;
    socket = MemorySocket();
    config = AppSocketConfig(socketFactory: (_, _) => socket);
    config.initSocket();
    Get.put(config);
    Get.put(
      ProcessoExecutavelModel.empty().copyWith(
        codEmpresa: 1,
        origem: 'CO',
        codOrigem: 81,
        codUsuario: 7,
        nomeUsuario: 'Teste',
      ),
    );
    socket.onconnect('service-test', null);
    socket.respond = (body) => socket.reply(body, {'Data': []});
  });
  tearDown(() {
    Get.reset();
  });

  Map<String, dynamic> filters(Map<String, dynamic> body) => {
    for (final param in body['Where'] as List)
      param['key'] as String: param['value'],
  };

  CarrinhoPercursoEstagioAdicionarService abrir() =>
      CarrinhoPercursoEstagioAdicionarService(
        carrinho: ExpedicaoCarrinhoModel(
          codEmpresa: 1,
          codCarrinho: 4,
          descricao: 'Teste',
          ativo: 'S',
          codigoBarras: '0004',
          situacao: 'CONFERINDO',
        ),
        carrinhoPercurso: percurso,
      );

  test(
    'sem estágio ativo não altera carrinho nem envia estágio zero',
    () async {
      await expectLater(abrir().execute(), throwsA(isA<AppError>()));
      expect(socket.sent, hasLength(1));
      expect(
        socket.sent.single['event'],
        endsWith(' expedicao.percurso.estagio.select'),
      );
      expect(filters(socket.sent.single), {'Origem': 'CO', 'Ativo': 'S'});
      expect(socket.sent.single['Pagination'], 'LIMIT=1&OFFSET=0&PAGE=1');
      expect(
        socket.sent.single['OrderBy'],
        'order_by=Sequencia,CodPercursoEstagio&order_direction=ASC,ASC',
      );
    },
  );

  test(
    'falha ao inserir estágio após atualizar carrinho exige reconciliação',
    () async {
      socket.respond = (body) {
        final event = socket.sent.last['event'] as String;
        if (event.endsWith('expedicao.percurso.estagio.select')) {
          socket.reply(body, {
            'Data': [
              {
                'CodPercursoEstagio': 8,
                'Descricao': 'Conferir',
                'Ativo': 'S',
                'Origem': 'CO',
                'Sequencia': 1,
              },
            ],
          });
        } else if (event.endsWith('carrinho.update')) {
          socket.reply(body, {'Mutation': body['Mutation']});
        } else {
          socket.reply(body, {
            'Error': ['[50014] Estágio recusado.'],
          });
        }
      };
      await expectLater(abrir().execute(), throwsA(isA<AppError>()));
      expect(config.recovery.needsRefresh, isTrue);
      expect(
        socket.sent.where((body) => body.containsKey('Mutation')),
        hasLength(2),
      );
      var reads = 0;
      config.recovery.register('documento', () async {
        reads++;
      });
      final before = socket.sent.length;
      await expectLater(abrir().execute(), throwsA(isA<AppError>()));
      expect(reads, 1);
      expect(socket.sent, hasLength(before));
    },
  );

  test('abertura relê estágio e envia origem CO sobre percurso SE', () async {
    var stage = 8;
    socket.respond = (body) {
      if (!body.containsKey('Mutation')) {
        socket.reply(body, {
          'Data': [
            {
              'CodPercursoEstagio': stage,
              'Descricao': 'Conferir',
              'Ativo': 'S',
              'Origem': 'CO',
              'Sequencia': 1,
            },
          ],
        });
      } else {
        socket.reply(body, {
          'Mutation': {...body['Mutation'] as Map, 'Item': '3'},
        });
      }
    };
    await abrir().execute();
    stage = 9;
    await abrir().execute();
    final inserts = socket.sent
        .where((e) => (e['event'] as String).endsWith('estagio.insert'))
        .toList();
    expect(inserts, hasLength(2));
    expect(inserts.map((e) => e['Mutation']['CodPercursoEstagio']), [8, 9]);
    final mutation = inserts.last['Mutation'] as Map;
    expect(mutation['CodEmpresa'], 1);
    expect(mutation['CodCarrinhoPercurso'], 31);
    expect(mutation['CodCarrinho'], 4);
    expect(mutation['Origem'], 'CO');
    expect(mutation['CodOrigem'], 81);
    expect(mutation['Situacao'], 'CONFERINDO');
    expect(mutation['CodUsuarioInicio'], 7);
  });

  test(
    'consulta de estágio ordena por percurso e item nas duas origens',
    () async {
      await SepararConsultaServices(
        codEmpresa: 1,
        codSepararEstoque: 71,
      ).carrinhosPercurso();
      await ConferirConsultaServices(
        codEmpresa: 1,
        codConferir: 81,
      ).carrinhosPercurso();
      expect(filters(socket.sent[0]), {
        'CodEmpresa': 1,
        'Origem': 'SE',
        'CodOrigem': 71,
      });
      expect(filters(socket.sent[1]), {
        'CodEmpresa': 1,
        'Origem': 'CO',
        'CodOrigem': 81,
      });
      for (final body in socket.sent) {
        expect(
          body['OrderBy'],
          'order_by=CodCarrinhoPercurso,Item&order_direction=ASC,ASC',
        );
      }
    },
  );

  test(
    'janela exige carrinho mas unidades consultam documento inteiro',
    () async {
      final service = ConferirConsultaServices(codEmpresa: 1, codConferir: 81);
      await service.itensConferir(codCarrinho: 4);
      await service.itensConferencia(codCarrinho: 4);
      await service.itensConferirUnidades();
      for (final body in socket.sent.take(2)) {
        expect(filters(body), {
          'CodEmpresa': 1,
          'CodConferir': 81,
          'CodCarrinho': 4,
        });
      }
      expect(filters(socket.sent.last), {'CodEmpresa': 1, 'CodConferir': 81});
      expect(
        socket.sent.last['OrderBy'],
        'order_by=Item,ItemUnidadeMedida&order_direction=ASC,ASC',
      );
    },
  );

  test('carrinhos a conferir usam chave composta na paginação', () async {
    await ConferirConsultaServices(
      codEmpresa: 1,
      codConferir: 81,
    ).carrinhosConferir();
    expect(
      socket.sent.single['OrderBy'],
      'order_by=CodCarrinhoPercurso,ItemCarrinhoPercurso&order_direction=ASC,ASC',
    );
  });

  test(
    'atualização seleciona percurso ativo mais recente antes de gravar',
    () async {
      socket.respond = (body) => socket.reply(
        body,
        body.containsKey('Mutation')
            ? {'Mutation': body['Mutation']}
            : {
                'Data': [percurso.toJson()],
              },
      );
      await ExpedicaoPercursoAtualizarService(
        codEmpresa: 1,
        origem: 'SE',
        codOrigem: 71,
        situacao: 'SEPARADO',
      ).execute();
      expect(
        socket.sent.first['OrderBy'],
        'order_by=CodCarrinhoPercurso&order_direction=DESC',
      );
      expect(socket.sent.first['Pagination'], 'LIMIT=1&OFFSET=0&PAGE=1');
      expect(socket.sent.last['Mutation']['CodCarrinhoPercurso'], 31);
      expect(socket.sent.last['Mutation']['Situacao'], 'SEPARADO');
      expect((socket.sent.first['Where'] as List).last, {
        'key': 'Situacao',
        'operator': '!=',
        'value': 'CANCELADA',
      });
    },
  );
}
