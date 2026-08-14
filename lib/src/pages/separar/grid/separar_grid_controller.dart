import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/app/app_color.dart';
import 'package:app_expedicao/src/app/app_data_grid.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_unidade_medida_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class SepararGridController extends GetxController {
  static const gridName = 'separarGrid';

  final iconSize = 19.0;

  final isComplitListiner = false.obs;
  Color selectedRowColor = AppColor.gridRowSelectedRowColor;

  final List<ExpedicaoSepararItemConsultaModel> _itens = [];
  final List<ExpedicaoSepararItemUnidadeMedidaConsultaModel> _itemUnids = [];

  final _processoExecutavel = Get.find<ProcessoExecutavelModel>();
  final dataGridController = DataGridController();
  final dataGridControllerSeparacao = DataGridController();

  String? highlightedItem;

  List<DataGridRow> get selectedoRows => dataGridController.selectedRows;
  int get selectedIndex => dataGridController.selectedIndex;

  List<ExpedicaoSepararItemConsultaModel> get itens => _itens;
  List<ExpedicaoSepararItemConsultaModel> get itensSort =>
      _itens.toList()..sort((a, b) => a.item.compareTo(b.item));


  @override
  void onClose() {
    isComplitListiner.close();
    super.onClose();
  }

  List<ExpedicaoSepararItemConsultaModel> getItensSort(int? codSetorEstoque) {
    if (codSetorEstoque == null) return itensSort;

    return itensSort.where((el) {
      if (el.codSetorEstoque == 0) return true;
      if (el.codSetorEstoque == codSetorEstoque) return true;

      return false;
    }).toList();
  }

  dynamic get itensSortSetor {
    return getItensSort(_processoExecutavel.codSetorEstoque);
  }

  void addGrid(ExpedicaoSepararItemConsultaModel item) {
    _itens.add(item);
    isComplitListiner.value = isComplit();
  }

  void addAllGrid(List<ExpedicaoSepararItemConsultaModel> itens) {
    _itens.addAll(itens);
    isComplitListiner.value = isComplit();
  }

  void updateGrid(ExpedicaoSepararItemConsultaModel item) {
    final index = _itens.indexWhere((el) => el.item == item.item);
    _itens[index] = item;
    isComplitListiner.value = isComplit();
  }

  void updateAllGrid(List<ExpedicaoSepararItemConsultaModel> itens) {
    for (var el in itens) {
      final index = _itens.indexWhere((i) => i.item == el.item);
      _itens[index] = el;
    }

    isComplitListiner.value = isComplit();
  }

  void removeGrid(ExpedicaoSepararItemConsultaModel item) {
    _itens.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codSepararEstoque == item.codSepararEstoque &&
        el.item == item.item);

    isComplitListiner.value = isComplit();
  }

  void removeAllGrid() {
    _itens.clear();

    isComplitListiner.value = false;
  }

  void addUnidade(ExpedicaoSepararItemUnidadeMedidaConsultaModel item) {
    _itemUnids.add(item);
  }

  void addAllUnidade(
      List<ExpedicaoSepararItemUnidadeMedidaConsultaModel> itens) {
    _itemUnids.addAll(itens);
  }

  void updateUnidade(ExpedicaoSepararItemUnidadeMedidaConsultaModel item) {
    final index = _itemUnids.indexWhere((el) => el.item == item.item);
    _itemUnids[index] = item;
  }

  void updateAllUnidade(
      List<ExpedicaoSepararItemUnidadeMedidaConsultaModel> itens) {
    for (var el in itens) {
      final index = _itemUnids.indexWhere((i) => i.item == el.item);
      _itemUnids[index] = el;
    }
  }

  void removeUnidade(ExpedicaoSepararItemUnidadeMedidaConsultaModel item) {
    _itemUnids.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codSepararEstoque == item.codSepararEstoque &&
        el.item == item.item);
  }

  bool _applyingSelection = false;
  bool get applyingSelection => _applyingSelection;

  void setSelectedRow(int index, {bool scroll = true}) {
    _applySelectedRow(dataGridController, index, scroll: scroll);
    _applySelectedRow(dataGridControllerSeparacao, index, scroll: scroll);
  }

  /// Um único foco de row: scan posiciona e rola; clique do usuário só troca a row.
  void highlightItem(String item, {bool scroll = true}) {
    if (highlightedItem == item && !scroll) {
      return;
    }

    _applyingSelection = true;
    highlightedItem = item;
    update();
    setSelectedRow(findIndexItem(item), scroll: scroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyingSelection = false;
    });
  }

  void _applySelectedRow(
    DataGridController target,
    int index, {
    bool scroll = true,
  }) {
    target.selectAndScrollToRow(index, scroll: scroll);
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

  ExpedicaoSepararItemConsultaModel findItem(String item) {
    final el = _itens.where((el) => el.item == item).toList();
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

  int? findCodProdutoFromBarCode(String barCode) {
    final el = _itemUnids.where((el) => el.codigoBarras == barCode).toList();
    return el.first.codProduto;
  }

  int findIndexCodProduto(int codProduto) {
    return itensSort.indexWhere((el) => el.codProduto == codProduto);
  }

  int findIndexItem(String item) {
    return itensSort.indexWhere((el) => el.item == item);
  }

  ExpedicaoSepararItemConsultaModel? findBarCode(String barCode) {
    final unidades =
        _itemUnids.where((el) => el.codigoBarras == barCode).toList();
    if (unidades.isEmpty) return null;

    final el = _itens.where((el) => el.item == unidades.first.item).toList();
    return el.first;
  }

  ExpedicaoSepararItemConsultaModel? findCodProduto(int codProduto) {
    final el = _itens.where((el) => el.codProduto == codProduto).toList();
    return el.first;
  }

  List<ExpedicaoSepararItemUnidadeMedidaConsultaModel>? findUnidadesProduto(
      int codProduto) {
    final el = _itemUnids.where((el) => el.codProduto == codProduto).toList();
    return el;
  }

  //
  Future<void> recalc() async {
    final repository = SeparacaoItemRepository();
    List<ExpedicaoSepararItemConsultaModel> separarItem = [];

    for (var el in _itens) {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', el.codEmpresa)
          .equals('CodSepararEstoque', el.codSepararEstoque)
          .equals('CodProduto', el.codProduto)
          .notEquals('Situacao', ExpedicaoSituacaoModel.cancelada);

      final separacaoItens = await repository.select(queryBuilder);

      if (separacaoItens.isEmpty) {
        separarItem.add(el.copyWith(quantidadeSeparacao: 0.00));
        continue;
      }

      double totalSeparado = separacaoItens.fold<double>(
          0.00, (previousValue, element) => previousValue + element.quantidade);

      separarItem.add(el.copyWith(quantidadeSeparacao: totalSeparado));
    }

    for (var el in separarItem) {
      updateGrid(el);
    }
  }

  bool isComplit() {
    for (var el in _itens) {
      if (el.quantidade != el.quantidadeSeparacao) return false;
    }

    return true;
  }

  Color rowColor(
    DataGridRow dataGridRow,
    ExpedicaoSepararItemConsultaModel el,
  ) {
    if (highlightedItem != null && el.item == highlightedItem) {
      return AppColor.gridRowSelectedRowColor;
    }

    if (el.quantidade == el.quantidadeSeparacao) {
      return AppColor.gridRowSelectedComplit;
    }

    return Colors.white;
  }

  Icon iconIndicator(ExpedicaoSepararItemConsultaModel item) {
    if (item.quantidade == item.quantidadeSeparacao) {
      return Icon(
        BootstrapIcons.check_circle_fill,
        color: Colors.green,
        size: iconSize,
      );
    }

    if (item.quantidade < item.quantidadeSeparacao) {
      return Icon(
        BootstrapIcons.exclamation_circle_fill,
        color: Colors.red,
        size: iconSize,
      );
    }

    if (_processoExecutavel.codSetorEstoque != null) {
      if (item.codSetorEstoque != _processoExecutavel.codSetorEstoque) {
        return Icon(
          BootstrapIcons.ban,
          color: Colors.red,
          size: iconSize,
        );
      }
    }

    return Icon(
      BootstrapIcons.box,
      color: Theme.of(Get.context!).primaryColor,
      size: iconSize,
    );
  }
}
