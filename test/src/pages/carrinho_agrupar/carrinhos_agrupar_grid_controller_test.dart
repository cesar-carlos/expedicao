import 'package:flutter_test/flutter_test.dart';

import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_consulta_model.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_controller.dart';

void main() {
  ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel item({
    required String itemCarrinhoPercurso,
    required String codigoBarrasCarrinho,
    int codCarrinho = 5,
  }) {
    return ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel(
      codEmpresa: 1,
      codCarrinhoPercurso: 10,
      itemCarrinhoPercurso: itemCarrinhoPercurso,
      origem: 'CO',
      codOrigem: 290,
      situacao: 'CONFERIDO',
      situacaoPercurso: 'EM ANDAMENTO',
      codCarrinho: codCarrinho,
      nomeCarrinho: 'Carrinho $codCarrinho',
      codigoBarrasCarrinho: codigoBarrasCarrinho,
      carrinhoAgrupador: 'N',
      dataInicio: DateTime(2026, 1, 1),
      horaInicio: '08:00:00',
      codUsuarioInicio: 1,
      nomeUsuarioInicio: 'Teste',
    );
  }

  test('findCodigoBarras ignora espaço de CHAR no código', () {
    final controller = CarrinhosAgruparGridController();
    controller.addGrid(item(
      itemCarrinhoPercurso: '00003',
      codigoBarrasCarrinho: '43174   ',
    ));

    expect(controller.findCodigoBarras('43174'), isNotNull);
    expect(controller.findCodigoBarras('43175'), isNull);
  });

  test('updateGrid acha a linha com Item 1 e 00001', () {
    final controller = CarrinhosAgruparGridController();
    controller.addGrid(item(itemCarrinhoPercurso: '00003', codigoBarrasCarrinho: 'A'));

    controller.updateGrid(
      item(itemCarrinhoPercurso: '3', codigoBarrasCarrinho: 'B'),
    );

    expect(controller.itens.single.codigoBarrasCarrinho, 'B');
  });

  test('updateAllGrid não para no item que a grade não tem', () {
    final controller = CarrinhosAgruparGridController();
    controller.addGrid(
      item(itemCarrinhoPercurso: '00001', codigoBarrasCarrinho: 'A', codCarrinho: 1),
    );
    controller.addGrid(
      item(itemCarrinhoPercurso: '00002', codigoBarrasCarrinho: 'B', codCarrinho: 2),
    );

    controller.updateAllGrid([
      item(itemCarrinhoPercurso: '00009', codigoBarrasCarrinho: 'X', codCarrinho: 9),
      item(itemCarrinhoPercurso: '00002', codigoBarrasCarrinho: 'B2', codCarrinho: 2),
    ]);

    expect(controller.itens[0].codigoBarrasCarrinho, 'A');
    expect(controller.itens[1].codigoBarrasCarrinho, 'B2');
  });
}
