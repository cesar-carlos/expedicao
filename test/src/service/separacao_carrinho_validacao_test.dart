import 'package:flutter_test/flutter_test.dart';

import 'package:app_expedicao/src/service/separacao_carrinho_validacao.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';

void main() {
  group('SeparacaoCarrinhoValidacao', () {
    SeparacaoQuantidadeItem item({
      int produto = 1,
      String unidade = 'UN',
      double quantidade = 1,
    }) {
      return (
        codProduto: produto,
        codUnidadeMedida: unidade,
        quantidade: quantidade,
      );
    }

    test('aceita quando a quantidade separada não excede o pedido', () {
      final valido = SeparacaoCarrinhoValidacao.quantidadeDentroDoPedido(
        separados: [item(quantidade: 5)],
        aSeparar: [item(quantidade: 8)],
      );

      expect(valido, isTrue);
    });

    test('rejeita quando um carrinho sozinho excede o pedido', () {
      final valido = SeparacaoCarrinhoValidacao.quantidadeDentroDoPedido(
        separados: [item(quantidade: 9)],
        aSeparar: [item(quantidade: 8)],
      );

      expect(valido, isFalse);
    });

    test('soma todos os carrinhos do mesmo produto e unidade', () {
      final valido = SeparacaoCarrinhoValidacao.quantidadeDentroDoPedido(
        separados: [item(quantidade: 5), item(quantidade: 5)],
        aSeparar: [item(quantidade: 8)],
        somenteItensDoCarrinho: [item(quantidade: 5)],
      );

      expect(valido, isFalse);
    });

    test('não mistura unidades diferentes do mesmo produto', () {
      final valido = SeparacaoCarrinhoValidacao.quantidadeDentroDoPedido(
        separados: [item(unidade: 'UN', quantidade: 11)],
        aSeparar: [
          item(unidade: 'UN', quantidade: 10),
          item(unidade: 'CX', quantidade: 2),
        ],
        somenteItensDoCarrinho: [item(unidade: 'UN', quantidade: 11)],
      );

      expect(valido, isFalse);
    });

    test('valida só os produtos do carrinho informado', () {
      final valido = SeparacaoCarrinhoValidacao.quantidadeDentroDoPedido(
        separados: [
          item(produto: 1, quantidade: 10),
          item(produto: 2, quantidade: 1),
        ],
        aSeparar: [
          item(produto: 1, quantidade: 8),
          item(produto: 2, quantidade: 5),
        ],
        somenteItensDoCarrinho: [item(produto: 2, quantidade: 1)],
      );

      expect(valido, isTrue);
    });

    test('carrinho vazio é considerado válido', () {
      final valido = SeparacaoCarrinhoValidacao.quantidadeDentroDoPedido(
        separados: [item(quantidade: 10)],
        aSeparar: [item(quantidade: 8)],
        somenteItensDoCarrinho: const [],
      );

      expect(valido, isTrue);
    });
  });

  group('SeparacaoCarrinhoValidacao.podeReabrir', () {
    test('permite reabrir carrinho SEPARADO com separação SEPARANDO', () {
      expect(
        SeparacaoCarrinhoValidacao.podeReabrir(
          situacaoSeparacao: ExpedicaoSituacaoModel.separando,
          situacaoCarrinho: ExpedicaoSituacaoModel.separado,
        ),
        isTrue,
      );
    });

    test('bloqueia quando a separação já está SEPARADO', () {
      expect(
        SeparacaoCarrinhoValidacao.podeReabrir(
          situacaoSeparacao: ExpedicaoSituacaoModel.separado,
          situacaoCarrinho: ExpedicaoSituacaoModel.separado,
        ),
        isFalse,
      );
    });

    test('bloqueia quando a separação está CANCELADA', () {
      expect(
        SeparacaoCarrinhoValidacao.podeReabrir(
          situacaoSeparacao: ExpedicaoSituacaoModel.cancelada,
          situacaoCarrinho: ExpedicaoSituacaoModel.separado,
        ),
        isFalse,
      );
    });

    test('bloqueia carrinho ainda SEPARANDO', () {
      expect(
        SeparacaoCarrinhoValidacao.podeReabrir(
          situacaoSeparacao: ExpedicaoSituacaoModel.separando,
          situacaoCarrinho: ExpedicaoSituacaoModel.separando,
        ),
        isFalse,
      );
    });

    test('bloqueia carrinho CANCELADA', () {
      expect(
        SeparacaoCarrinhoValidacao.podeReabrir(
          situacaoSeparacao: ExpedicaoSituacaoModel.separando,
          situacaoCarrinho: ExpedicaoSituacaoModel.cancelada,
        ),
        isFalse,
      );
    });
  });
}
