import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SepararGridController extends GetxController {
  final RxList<ExpedicaoSepararItemConsultaModel> _itens = RxList.empty();
  final DataGridController dataGridController = DataGridController();

  List<ExpedicaoSepararItemConsultaModel> get itens => _itens;
  List<ExpedicaoSepararItemConsultaModel> get itensSort =>
      _itens.toList()..sort((a, b) => a.item.compareTo(b.item));

  addItem(ExpedicaoSepararItemConsultaModel item) {
    _itens.add(item);
  }

  removeItem(ExpedicaoSepararItemConsultaModel item) {
    _itens.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codSepararEstoque == item.codSepararEstoque &&
        el.item == item.item);
  }

  updateItem(ExpedicaoSepararItemConsultaModel item) {
    final index = _itens.indexWhere((el) => el.item == item.item);
    dataGridController.selectedIndex = index;
    _itens[index] = item;
  }

  removeAll() {
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
    final itens = _itens.where((el) => el.codigoBarras == barCode).toList();
    if (itens.isEmpty) return false;
    return true;
  }

  bool existsCodProduto(int codProduto) {
    final item = _itens.where((el) => el.codProduto == codProduto).toList();
    if (item.isEmpty) return false;
    return true;
  }

  int findcodProdutoFromBarCode(String barCode) {
    final itens = _itens.where((el) => el.codigoBarras == barCode).toList();
    return itens.first.codProduto;
  }

  ExpedicaoSepararItemConsultaModel findBarCode(String barCode) {
    final itens = _itens.where((el) => el.codigoBarras == barCode).toList();
    return itens.first;
  }

  ExpedicaoSepararItemConsultaModel findCodProduto(int codProduto) {
    final itens = _itens.where((el) => el.codProduto == codProduto).toList();
    return itens.first;
  }
}
