import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/service/carrinho_recovery_validation.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_cancelar_service.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_finalizar_service.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_reabrir_service.dart';

import '../app/app_socket_recovery_test.dart' show MemorySocket;

ExpedicaoCarrinhoPercursoEstagioModel stage({
  int percurso = 10,
  String item = '1',
  String situation = 'SEPARADO',
  String origin = 'SE',
  int document = 71,
}) => ExpedicaoCarrinhoPercursoEstagioModel(
  codEmpresa: 1,
  codCarrinhoPercurso: percurso,
  item: item,
  origem: origin,
  codOrigem: document,
  codPercursoEstagio: 8,
  codCarrinho: 4,
  situacao: situation,
  dataInicio: DateTime(2026, 11, 13),
  horaInicio: '10:00:00',
  codUsuarioInicio: 7,
  nomeUsuarioInicio: 'Teste',
);

void main() {
  void validate(
    ExpedicaoCarrinhoPercursoEstagioModel target,
    String registration, [
    List<ExpedicaoCarrinhoPercursoEstagioModel>? history,
  ]) => CarrinhoRecoveryValidation.validateCadastro(
    documentStages: [target],
    history: history ?? [target],
    registrations: {4: registration},
  );

  for (final old in ['CANCELADA', 'SEPARADO', 'CONFERIDO', 'AGRUPADO']) {
    test('histórico $old não compara cadastro ocupado por outro documento', () {
      final target = stage(situation: old);
      expect(
        () => validate(target, 'EM CONFERENCIA', [
          stage(
            percurso: 11,
            situation: 'CONFERINDO',
            origin: 'CO',
            document: 90,
          ),
          target,
        ]),
        returnsNormally,
      );
    });
  }
  test('estágio antigo aberto junto de uso mais novo é inconsistência', () {
    final target = stage(situation: 'SEPARANDO');
    expect(
      () => validate(target, 'EM SEPARACAO', [
        target,
        stage(percurso: 11, situation: 'SEPARANDO', document: 90),
      ]),
      throwsA(isA<AppError>()),
    );
  });
  test(
    'Item é ordenado numericamente e inclui cancelados no mesmo percurso',
    () {
      final target = stage(item: '9', situation: 'SEPARADO');
      expect(
        () => validate(target, 'LIBERADO', [
          stage(item: '10', situation: 'CANCELADA'),
          target,
        ]),
        returnsNormally,
      );
      expect(
        () => validate(stage(item: '10', situation: 'CANCELADA'), 'SEPARADO', [
          target,
          stage(item: '00010', situation: 'CANCELADA'),
        ]),
        throwsA(isA<AppError>()),
      );
    },
  );
  for (final combination in [
    ('SE', 'SEPARANDO', 'LIBERADO'),
    ('SE', 'SEPARADO', 'EM SEPARACAO'),
    ('SE', 'CANCELADA', 'EM SEPARACAO'),
    ('CO', 'CONFERINDO', 'CONFERIDO'),
    ('CO', 'CONFERIDO', 'EM CONFERENCIA'),
    ('CO', 'AGRUPADO', 'CONFERIDO'),
  ]) {
    test(
      'bloqueia cadastro ${combination.$3} no estágio atual ${combination.$2}',
      () {
        expect(
          () => validate(
            stage(origin: combination.$1, situation: combination.$2),
            combination.$3,
          ),
          throwsA(isA<AppError>()),
        );
      },
    );
  }
  test(
    'cancelamento CO mantém cadastro em conferência e liberação SE é válida',
    () {
      expect(
        () => validate(
          stage(origin: 'CO', situation: 'CANCELADA'),
          'EM CONFERENCIA',
        ),
        returnsNormally,
      );
      expect(() => validate(stage(), 'LIBERADO'), returnsNormally);
    },
  );
  test('cadastro ausente impede liberação da recuperação', () {
    expect(
      () => CarrinhoRecoveryValidation.validateCadastro(
        documentStages: [stage()],
        history: [stage()],
        registrations: {},
      ),
      throwsA(isA<AppError>()),
    );
  });

  group('serviços com transporte em memória', () {
    late MemorySocket socket;
    late AppSocketConfig config;
    setUp(() {
      Get.testMode = true;
      socket = MemorySocket();
      config = AppSocketConfig(socketFactory: (_, _) => socket);
      config.initSocket();
      Get.put(config);
      Get.put(ProcessoExecutavelModel.empty());
      socket.onconnect('cadastro-test', null);
    });
    tearDown(() {
      Get.reset();
    });
    for (final operation in ['cancelar', 'finalizar', 'reabrir']) {
      test('$operation não grava no carrinho reutilizado', () async {
        socket.respond = (body) => socket.reply(body, {
          'Data': [stage(percurso: 11, document: 90).toJson()],
        });
        final cart = ExpedicaoCarrinhoModel(
          codEmpresa: 1,
          codCarrinho: 4,
          descricao: 'Teste',
          ativo: 'S',
          codigoBarras: '4',
          situacao: 'LIBERADO',
        );
        final Future<void> action = switch (operation) {
          'cancelar' => CarrinhoPercursoEstagioCancelarService(
            carrinho: cart,
            percursoEstagio: stage(),
          ).execute(),
          'finalizar' => CarrinhoPercursoEstagioFinalizarService(
            carrinho: cart,
            carrinhoPercursoEstagio: stage(),
          ).execute(),
          _ => CarrinhoPercursoEstagioReabrirService(
            carrinho: cart,
            carrinhoPercursoEstagio: stage(),
          ).execute(),
        };
        await expectLater(action, throwsA(isA<AppError>()));
        expect(socket.sent, hasLength(1));
        expect(config.recovery.needsRefresh, isTrue);
        expect(socket.sent.single.containsKey('Mutation'), isFalse);
        expect(
          {
            for (final p in socket.sent.single['Where'] as List)
              p['key']: p['value'],
          },
          {'CodEmpresa': 1, 'CodCarrinho': 4},
        );
      });
    }
    test('recuperação consulta histórico sem filtro de documento antes de validar cadastro', () async {
      final old = stage(situation: 'CANCELADA');
      final current = stage(percurso: 11, document: 90, situation: 'SEPARANDO');
      socket.respond = (body) {
        final event = socket.sent.last['event'] as String;
        final where = {
          for (final p in body['Where'] as List) p['key']: p['value'],
        };
        if (event.endsWith('estagio.select')) {
          socket.reply(body, {
            'Data': where.containsKey('CodOrigem')
                ? [old.toJson()]
                : [old.toJson(), current.toJson()],
          });
        } else if (event.endsWith('carrinho.select')) {
          socket.reply(body, {
            'Data': [
              {
                'CodEmpresa': 1,
                'CodCarrinho': 4,
                'Descricao': 'Teste',
                'Ativo': 'S',
                'CodigoBarras': '4',
                'Situacao': 'EM SEPARACAO',
              },
            ],
          });
        } else {
          socket.reply(body, {'Data': []});
        }
      };
      await CarrinhoRecoveryValidation.reloadAndValidate(
        codEmpresa: 1,
        codDocumento: 71,
        conferencia: false,
      );
      expect(socket.sent, hasLength(4));
      expect(
        socket.sent.every((body) => !body.containsKey('Mutation')),
        isTrue,
      );
      expect(
        {for (final p in socket.sent[2]['Where'] as List) p['key']: p['value']},
        {
          'CodEmpresa': 1,
          'CodCarrinho': [4],
        },
      );
    });
  });
}
