import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/app/socket_recovery.dart';
import 'package:app_expedicao/src/service/carrinho_recovery_validation.dart';

import '../app/app_socket_recovery_test.dart' show MemorySocket;
import '../app/two_collectors_recovery_test.dart' show ServerFixture;

void main() {
  for (final situation in [
    'CANCELADA',
    'SEPARANDO',
    'CONFERINDO',
    'EM SEPARACAO',
    'EM CONFERENCIA',
  ]) {
    test(
      '$situation com itens de operação parcial mantém bloqueio após atualizar todas as grades',
      () async {
        final recovery = SocketRecovery(canRead: () => true);
        final order = <String>[];
        var states = situation == 'CANCELADA' ? ['CA', 'SP'] : ['SP', 'FN'];
        recovery.register('documento', () async {
          order.add('documento');
        });
        recovery.register('carrinho', () async {
          order.add('carrinho');
        });
        recovery.registerValidator('documento', () async {
          order.add('validacao');
          CarrinhoRecoveryValidation.validate(
            stages: [(percurso: 10, item: '00001', situacao: situation)],
            items: states.map((s) => (percurso: 10, estagio: '1', situacao: s)),
          );
        });
        recovery.mutationUncertain();
        await expectLater(recovery.beforeMutation(), throwsA(isA<AppError>()));
        expect(order, ['documento', 'carrinho', 'validacao']);
        expect(recovery.needsRefresh, isTrue);
        expect(recovery.blocksMutation, isTrue);
        // Simula regularização externa; a recuperação nunca grava no servidor.
        states = situation == 'CANCELADA' ? ['CA', 'CA'] : ['SP', 'SP'];
        await expectLater(recovery.beforeMutation(), throwsA(isA<AppError>()));
        expect(recovery.needsRefresh, isFalse);
        await recovery.beforeMutation();
      },
    );
  }

  for (final situation in ['SEPARADO', 'CONFERIDO', 'AGRUPADO']) {
    test(
      '$situation aceita estados ativos legados junto de FN e itens cancelados',
      () {
        expect(
          () => CarrinhoRecoveryValidation.validate(
            stages: [(percurso: 10, item: '1', situacao: situation)],
            items: [
              'SP',
              'CO',
              'FN',
              'CA',
            ].map((s) => (percurso: 10, estagio: '1', situacao: s)),
          ),
          returnsNormally,
        );
      },
    );
  }

  test('não mistura estágios com mesmo Item em percursos diferentes', () {
    expect(
      () => CarrinhoRecoveryValidation.validate(
        stages: [
          (percurso: 10, item: '1', situacao: 'CANCELADA'),
          (percurso: 11, item: '1', situacao: 'SEPARADO'),
        ],
        items: [
          (percurso: 10, estagio: '00001', situacao: 'CA'),
          (percurso: 11, estagio: '1', situacao: 'FN'),
        ],
      ),
      returnsNormally,
    );
  });

  test('fechar documento remove seu validador', () async {
    final recovery = SocketRecovery(canRead: () => true);
    recovery.register('aberto', () async {});
    recovery.register('fechado', () async {});
    recovery.registerValidator('fechado', () async {
      throw StateError('não executar');
    });
    recovery.unregister('fechado');
    recovery.invalidate();
    await recovery.refresh();
    expect(recovery.needsRefresh, isFalse);
  });

  for (final conference in [false, true]) {
    test(
      '${conference ? 'CO' : 'SE'} consulta tabela por documento e não emite mutação na falha parcial',
      () async {
        Get.testMode = true;
        final socket = MemorySocket();
        final config = AppSocketConfig(socketFactory: (_, _) => socket);
        config.initSocket();
        Get.put(config);
        socket.onconnect('validation-test', null);
        addTearDown(() {
          Get.reset();
        });
        final fixture = ServerFixture(
          conference ? 'conferencia.item' : 'separacao.item',
        );
        socket.respond = (body) {
          final event = socket.sent.last['event'] as String;
          if (event.endsWith('estagio.select')) {
            socket.reply(body, {
              'Data': [
                {
                  'CodEmpresa': 1,
                  'CodCarrinhoPercurso': 100,
                  'Item': '00001',
                  'Origem': conference ? 'CO' : 'SE',
                  'CodOrigem': 10,
                  'CodPercursoEstagio': 8,
                  'CodCarrinho': 94,
                  'Situacao': 'CANCELADA',
                  'DataInicio': '2026-11-13',
                  'HoraInicio': '10:00:00',
                  'CodUsuarioInicio': 7,
                  'NomeUsuarioInicio': 'Teste',
                },
              ],
            });
          } else {
            socket.reply(body, {
              'Data': [fixture.makeRow(1, 1, 'validation-test')],
            });
          }
        };
        config.recovery.register('grade', () async {});
        config.recovery.registerValidator(
          'grade',
          () => CarrinhoRecoveryValidation.reloadAndValidate(
            codEmpresa: 1,
            codDocumento: 10,
            conferencia: conference,
          ),
        );
        config.recovery.invalidate();
        await expectLater(config.recovery.refresh(), throwsA(isA<AppError>()));
        expect(config.recovery.blocksMutation, isTrue);
        expect(socket.sent, hasLength(2));
        expect(
          socket.sent.every((body) => !body.containsKey('Mutation')),
          isTrue,
        );
        expect(
          socket.sent.last['event'],
          endsWith(
            conference ? ' conferencia.item.select' : ' separacao.item.select',
          ),
        );
        final filters = {
          for (final param in socket.sent.last['Where'] as List)
            param['key']: param['value'],
        };
        expect(filters, {
          'CodEmpresa': 1,
          conference ? 'CodConferir' : 'CodSepararEstoque': 10,
        });
      },
    );
  }
}
