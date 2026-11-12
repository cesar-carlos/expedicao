import 'package:flutter_test/flutter_test.dart';

import 'package:app_expedicao/src/app/app_helper.dart';

void main() {
  group('AppHelper.sameGridItem', () {
    test('trata 6 e 00006 como o mesmo item', () {
      expect(AppHelper.gridItemKey('00006'), '6');
      expect(AppHelper.gridItemKey(6), '6');
      expect(AppHelper.sameGridItem('00006', 6), isTrue);
      expect(AppHelper.sameGridItem('00006', '00007'), isFalse);
    });
  });

  group('AppHelper.sameBarCode', () {
    test('ignora espaços nas pontas', () {
      expect(AppHelper.sameBarCode('43174   ', '43174'), isTrue);
      expect(AppHelper.sameBarCode(' 789123 ', '789123'), isTrue);
    });

    test('recusa vazio ou diferente', () {
      expect(AppHelper.sameBarCode(null, '43174'), isFalse);
      expect(AppHelper.sameBarCode('', '43174'), isFalse);
      expect(AppHelper.sameBarCode('43174', ''), isFalse);
      expect(AppHelper.sameBarCode('43174', '43175'), isFalse);
    });
  });

  group('AppHelper.conversaoCodigo', () {
    test('lê CodigoBarras ou Codigo e corta espaço', () {
      expect(
        AppHelper.conversaoCodigo({'CodigoBarras': '43174   '}),
        '43174',
      );
      expect(AppHelper.conversaoCodigo({'Codigo': 43174}), '43174');
      expect(AppHelper.conversaoCodigo({}), isNull);
    });
  });

  group('AppHelper.itemSequenceKey', () {
    test('itemSequenceKey devolve a chave de 5 dígitos da tabela', () {
      expect(AppHelper.itemSequenceKey('1'), '00001');
      expect(AppHelper.itemSequenceKey(1), '00001');
      expect(AppHelper.itemSequenceKey('00001'), '00001');
      expect(AppHelper.itemSequenceKey(''), '00000');
    });
  });

  group('AppHelper.setorDefinido', () {
    test('só aceita código maior que zero', () {
      expect(AppHelper.setorDefinido(null), isFalse);
      expect(AppHelper.setorDefinido(0), isFalse);
      expect(AppHelper.setorDefinido(-1), isFalse);
      expect(AppHelper.setorDefinido(1), isTrue);
      expect(AppHelper.setorDefinido(5), isTrue);
    });
  });

  group('AppHelper.setorPermitido', () {
    test('libera se o usuário não tem setor', () {
      expect(AppHelper.setorPermitido(null, 5), isTrue);
    });

    test('libera se o usuário tem setor zero', () {
      expect(AppHelper.setorPermitido(0, 5), isTrue);
    });

    test('libera se o item não tem setor', () {
      expect(AppHelper.setorPermitido(5, null), isTrue);
    });

    test('libera se o item tem setor zero', () {
      expect(AppHelper.setorPermitido(5, 0), isTrue);
    });

    test('libera se os dois lados são zero', () {
      expect(AppHelper.setorPermitido(0, 0), isTrue);
    });

    test('libera se os setores são iguais', () {
      expect(AppHelper.setorPermitido(5, 5), isTrue);
    });

    test('recusa se os setores são diferentes e maiores que zero', () {
      expect(AppHelper.setorPermitido(5, 7), isFalse);
    });
  });

  group('AppHelper.quantidadeRecuperar', () {
    test('devolve a quantidade cancelada se cabe no restante', () {
      expect(
        AppHelper.quantidadeRecuperar(
          quantidadeCancelada: 3,
          quantidadePedido: 10,
          quantidadeJaSeparada: 2,
        ),
        3,
      );
    });

    test('corta no restante se a cancelada estoura o pedido', () {
      expect(
        AppHelper.quantidadeRecuperar(
          quantidadeCancelada: 8,
          quantidadePedido: 10,
          quantidadeJaSeparada: 6,
        ),
        4,
      );
    });

    test('devolve zero se o pedido já está completo', () {
      expect(
        AppHelper.quantidadeRecuperar(
          quantidadeCancelada: 5,
          quantidadePedido: 10,
          quantidadeJaSeparada: 10,
        ),
        0,
      );
    });
  });
}
