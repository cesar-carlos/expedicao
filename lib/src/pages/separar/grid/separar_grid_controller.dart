import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SepararGridController extends GetxController {
  final RxList<ExpedicaoSepararItemConsultaModel> _itens = RxList.empty();
  final DataGridController dataGridController = DataGridController();

  List<ExpedicaoSepararItemConsultaModel> get itens => _itens;
  List<ExpedicaoSepararItemConsultaModel> get itensSort =>
      _itens.toList()..sort((a, b) => a.item.compareTo(b.item));

  void add(ExpedicaoSepararItemConsultaModel item) {
    _itens.add(item);
  }

  void addAll(List<ExpedicaoSepararItemConsultaModel> itens) =>
      _itens.addAll(itens);

  void updateItem(ExpedicaoSepararItemConsultaModel item) {
    final index = _itens.indexWhere((el) => el.item == item.item);
    dataGridController.selectedIndex = index;
    _itens[index] = item;
  }

  void remove(ExpedicaoSepararItemConsultaModel item) {
    _itens.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codSepararEstoque == item.codSepararEstoque &&
        el.item == item.item);
  }

  void removeAll() {
    _itens.clear();
  }

  double totalQuantity() {
    return _itens.fold<double>(0.00, (acm, el) => acm + el.quantidade);
  }

  double totalQuantitySeparetion() {
    return _itens.fold<double>(0.00, (acm, el) => acm + el.quantidadeSeparacao);
  }

  double totalQtdProduct(int codProduto) {
    return _itens
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidade);
  }

  double totalQtdProductInternal(int codProduto) {
    return _itens
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidadeInterna);
  }

  double totalQtdProductExternal(int codProduto) {
    return _itens
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidadeExterna);
  }

  double totalQtdProductSeparation(int codProduto) {
    return _itens
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidadeSeparacao);
  }

  bool existsBarCode(String barCode) {
    final el = _itens.where((el) => el.codigoBarras == barCode).toList();
    if (el.isEmpty) return false;
    return true;
  }

  bool existsCodProduto(int codProduto) {
    final el = _itens.where((el) => el.codProduto == codProduto).toList();
    if (el.isEmpty) return false;
    return true;
  }

  int? findcodProdutoFromBarCode(String barCode) {
    final el = _itens.where((el) => el.codigoBarras == barCode).toList();
    return el.first.codProduto;
  }

  ExpedicaoSepararItemConsultaModel? findBarCode(String barCode) {
    final el = _itens.where((el) => el.codigoBarras == barCode).toList();
    return el.first;
  }

  ExpedicaoSepararItemConsultaModel? findCodProduto(int codProduto) {
    final el = _itens.where((el) => el.codProduto == codProduto).toList();
    return el.first;
  }

  Future<void> recalc() async {
    final repository = SeparacaoItemRepository();
    List<ExpedicaoSepararItemConsultaModel> separarItem = [];

    for (var el in _itens) {
      final separacaoItens = await repository.select('''
            CodEmpresa = ${el.codEmpresa}
        AND CodSepararEstoque = ${el.codSepararEstoque}
        AND CodProduto = ${el.codProduto}
        AND Situacao <> ${ExpedicaoSituacaoModel.cancelada}
      ''');

      if (separacaoItens.isEmpty) {
        separarItem.add(el.copyWith(quantidadeSeparacao: 0.00));
        continue;
      }

      double totalSeparado = separacaoItens.fold<double>(
          0.00, (previousValue, element) => previousValue + element.quantidade);

      separarItem.add(el.copyWith(quantidadeSeparacao: totalSeparado));
    }

    for (var el in separarItem) {
      updateItem(el);
    }
  }
}
