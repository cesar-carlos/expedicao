import 'package:flutter_test/flutter_test.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_error_alert.dart';

void main() {
  group('AppError.socketMessage', () {
    test('preserva o prefixo da trigger', () {
      expect(
        AppError.socketMessage([
          '[50014] Carrinho sem itens para conferir. Nao e possivel iniciar a conferencia deste carrinho.',
        ]),
        '[50014] Carrinho sem itens para conferir. Nao e possivel iniciar a conferencia deste carrinho.',
      );
    });

    test('preserva prefixos SQL e de contrato', () {
      expect(
        AppError.socketMessage('[SQL-CONN] Falha de conexao com o banco.'),
        '[SQL-CONN] Falha de conexao com o banco.',
      );
      expect(
        AppError.socketMessage('[INVALID_PAYLOAD] Where invalido'),
        '[INVALID_PAYLOAD] Where invalido',
      );
      expect(
        AppError.socketMessage('[UNAUTHORIZED] Sem permissao'),
        '[UNAUTHORIZED] Sem permissao',
      );
      expect(
        AppError.socketMessage('[NOT_FOUND] Registro ausente'),
        '[NOT_FOUND] Registro ausente',
      );
      expect(
        AppError.socketMessage('[INTERNAL_ERROR] Falha nao classificada'),
        '[INTERNAL_ERROR] Falha nao classificada',
      );
    });

    test('le Error de envelope Socket', () {
      expect(
        AppError.socketMessage({
          'Session': 'abc',
          'Error': ['[50016] Ja existe conferencia ativa.'],
          'Code': 'BUSINESS_RULE_VIOLATION',
        }),
        '[50016] Ja existe conferencia ativa.',
      );
    });

    test('nao embrulha de novo um AppError', () {
      final original = AppError('[50014] Carrinho sem itens para conferir.');
      expect(AppError.socketMessage(original), original.message);
    });

    test('remove prefixos Dart sem apagar o contrato', () {
      expect(
        AppError.socketMessage(
          'Exception: [50014] Carrinho sem itens para conferir.',
        ),
        '[50014] Carrinho sem itens para conferir.',
      );
    });

    test('nulo vira mensagem padrao', () {
      expect(
        AppError.socketMessage(null),
        'Não foi possível concluir a operação.',
      );
    });
  });

  group('AppError.fromUnknown', () {
    test('preserva AppError e AppErrorAlert', () {
      final error = AppError('[SQL-208] Falha ao processar no banco.');
      expect(identical(AppError.fromUnknown(error), error), isTrue);

      final alert = AppErrorAlert('Carrinho não encontrado');
      expect(AppError.fromUnknown(alert), same(alert));
      expect(AppError.fromUnknown(alert), isA<AppErrorAlert>());
    });

    test('nao cria Exception com prefixo Erro ao', () {
      final parsed = AppError.fromUnknown([
        '[50014] Carrinho sem itens para conferir.',
      ]);
      expect(parsed.message, '[50014] Carrinho sem itens para conferir.');
      expect(parsed.toString(), parsed.message);
      expect(parsed.toString(), isNot(contains('AppError{')));
    });
  });

  group('AppError.fromResponse', () {
    test('extrai Error e Code do envelope', () {
      final parsed = AppError.fromResponse({
        'Error': ['[50014] Carrinho sem itens para conferir.'],
        'Code': 'BUSINESS_RULE_VIOLATION',
      });

      expect(parsed.message, '[50014] Carrinho sem itens para conferir.');
      expect(parsed.contractCode, 'BUSINESS_RULE_VIOLATION');
    });
  });

  group('AppError.display', () {
    test('mostra o texto claro, sem o codigo tecnico no titulo da frase', () {
      expect(
        AppError.display([
          '[50014] Carrinho sem itens para conferir.',
        ]),
        'Carrinho sem itens para conferir.',
      );
      expect(
        AppError.display(AppErrorAlert('Não há carrinhos para agrupar')),
        'Não há carrinhos para agrupar',
      );
    });

    test('traduz falha de rede para o operador', () {
      expect(
        AppError.display('DioException [connection error]: SocketException'),
        'Não foi possível conectar ao servidor. Verifique a rede e o endereço da API.',
      );
    });
  });

  group('AppError titulo e detalhe', () {
    test('separa titulo, texto e codigo para a tela', () {
      final error = AppError.fromUnknown([
        '[50014] Carrinho sem itens para conferir. Nao e possivel iniciar a conferencia deste carrinho.',
      ]);

      expect(error.title, 'Operação não permitida');
      expect(
        error.userMessage,
        'Carrinho sem itens para conferir. Nao e possivel iniciar a conferencia deste carrinho.',
      );
      expect(error.userDetail, contains('Código 50014'));
      expect(error.identifier, '50014');
    });

    test('alerta de negocio usa a propria frase como titulo', () {
      final alert = AppErrorAlert(
        'Carrinho não encontrado',
        details: 'O carrinho informado não está no percurso.',
      );

      expect(alert.title, 'Carrinho não encontrado');
      expect(alert.userDetail, contains('O carrinho informado não está no percurso.'));
    });
  });
}
