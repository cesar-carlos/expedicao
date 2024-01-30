import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_unidade_medida_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class ConferirGridController extends GetxController {
  static const gridName = 'conferirGrid';
  final iconSize = 19.0;

  final List<ExpedicaoConferirItemConsultaModel> _itens = [];
  final List<ExpedicaoConferirItemUnidadeMedidaConsultaModel> _itemUnids = [];
  final dataGridController = DataGridController();

  List<DataGridRow> get selectedoRows => dataGridController.selectedRows;
  List<ExpedicaoConferirItemConsultaModel> get itens => _itens;
  List<ExpedicaoConferirItemConsultaModel> get itensSort =>
      _itens.toList()..sort((a, b) => a.item.compareTo(b.item));

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    dataGridController.dispose();
  }

  void addGrid(ExpedicaoConferirItemConsultaModel item) {
    _itens.add(item);
  }

  void addAllGrid(List<ExpedicaoConferirItemConsultaModel> itens) {
    _itens.addAll(itens);
  }

  void updateGrid(ExpedicaoConferirItemConsultaModel item) {
    final index = _itens.indexWhere((el) => el.item == item.item);
    _itens[index] = item;
  }

  void updateAllGrid(List<ExpedicaoConferirItemConsultaModel> itens) {
    for (var el in itens) {
      final index = _itens.indexWhere((i) => i.item == el.item);
      _itens[index] = el;
    }
  }

  void removeGrid(ExpedicaoConferirItemConsultaModel item) {
    _itens.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codConferir == item.codConferir &&
        el.item == item.item);
  }

  void removeAllGrid() {
    _itens.clear();
  }

  void addUnidade(ExpedicaoConferirItemUnidadeMedidaConsultaModel item) {
    _itemUnids.add(item);
  }

  void addAllUnidade(
      List<ExpedicaoConferirItemUnidadeMedidaConsultaModel> itens) {
    _itemUnids.addAll(itens);
  }

  void updateUnidade(ExpedicaoConferirItemUnidadeMedidaConsultaModel item) {
    final index = _itemUnids.indexWhere((el) => el.item == item.item);
    _itemUnids[index] = item;
  }

  void updateAllUnidade(
      List<ExpedicaoConferirItemUnidadeMedidaConsultaModel> itens) {
    for (var el in itens) {
      final index = _itemUnids.indexWhere((i) => i.item == el.item);
      _itemUnids[index] = el;
    }
  }

  void removeUnidade(ExpedicaoConferirItemUnidadeMedidaConsultaModel item) {
    _itemUnids.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codConferir == item.codConferir &&
        el.item == item.item);
  }

  //
  void setSelectedRow(int index) {
    Future.delayed(const Duration(milliseconds: 150), () async {
      dataGridController.selectedIndex = index;
      dataGridController.scrollToRow(
        index.toDouble(),
        canAnimate: true,
        position: DataGridScrollPosition.center,
      );
    });
  }

  double totalQuantity() {
    return _itens.fold<double>(0.00, (acm, el) => acm + el.quantidade);
  }

  double totalQuantitySeparetion() {
    return _itens.fold<double>(0.00, (acm, el) => acm + el.quantidadeConferida);
  }

  double totalQtdProduct(int codProduto) {
    return _itens
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidade);
  }

  double totalQtdProductChecked(int codProduto) {
    return _itens
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidadeConferida);
  }

  //LOCALIZACAO
  ExpedicaoConferirItemConsultaModel findItem(String Item) {
    final el = _itens.where((el) => el.item == Item).toList();
    return el.first;
  }

  bool existsBarCode(String barCode) {
    final el = _itemUnids.where((el) => el.codigoBarras == barCode).toList();
    if (el.isEmpty) return false;
    return true;
  }

  bool existsCodProduto(int codProduto) {
    final el = _itens.where((el) => el.codProduto == codProduto).toList();
    if (el.isEmpty) return false;
    return true;
  }

  int? findcodProdutoFromBarCode(String barCode) {
    final el = _itemUnids.where((el) => el.codigoBarras == barCode).toList();
    return el.first.codProduto;
  }

  int findIndexCodProduto(int codProduto) {
    final el = _itens.where((el) => el.codProduto == codProduto).toList();
    return _itens.indexOf(el.first);
  }

  ExpedicaoConferirItemConsultaModel? findBarCode(String barCode) {
    final unidades =
        _itemUnids.where((el) => el.codigoBarras == barCode).toList();
    if (unidades.isEmpty) return null;

    final el = _itens.where((el) => el.item == unidades.first.item).toList();
    if (el.isEmpty) return null;
    return el.first;
  }

  ExpedicaoConferirItemConsultaModel? findCodProduto(int codProduto) {
    final el = _itens.where((el) => el.codProduto == codProduto).toList();
    if (el.isEmpty) return null;
    return el.first;
  }

  List<ExpedicaoConferirItemUnidadeMedidaConsultaModel>? findUnidadesProduto(
      int codProduto) {
    final el = _itemUnids.where((el) => el.codProduto == codProduto).toList();
    return el;
  }

  Future<void> recalc() async {
    final repository = SeparacaoItemRepository();
    List<ExpedicaoConferirItemConsultaModel> conferirItem = [];

    for (var el in _itens) {
      final separacaoItens = await repository.select('''
          CodEmpresa = ${el.codEmpresa}
        AND CodConferirEstoque = ${el.codConferir}
        AND CodProduto = ${el.codProduto}
        AND Situacao <> ${ExpedicaoSituacaoModel.cancelada}
        
      ''');

      if (separacaoItens.isEmpty) {
        conferirItem.add(el.copyWith(quantidadeConferida: 0.00));
        continue;
      }

      double totalSeparado = separacaoItens.fold<double>(
          0.00, (previousValue, element) => previousValue + element.quantidade);

      conferirItem.add(el.copyWith(quantidadeConferida: totalSeparado));
    }

    for (var el in conferirItem) {
      updateGrid(el);
    }
  }

  Color rowColor(ExpedicaoConferirItemConsultaModel item) {
    if (item.quantidade == item.quantidadeConferida) {
      return Color(0xFFffff00);
    }

    return Colors.white;
  }

  iconIndicator(ExpedicaoConferirItemConsultaModel item) {
    if (item.quantidade == item.quantidadeConferida) {
      return Icon(
        BootstrapIcons.check_circle_fill,
        color: Colors.green,
        size: iconSize,
      );
    }

    if (item.quantidade < item.quantidadeConferida) {
      return Icon(
        BootstrapIcons.exclamation_circle_fill,
        color: Colors.red,
        size: iconSize,
      );
    }

    return Icon(
      BootstrapIcons.box,
      color: Colors.blue,
      size: iconSize,
    );
  }
}
