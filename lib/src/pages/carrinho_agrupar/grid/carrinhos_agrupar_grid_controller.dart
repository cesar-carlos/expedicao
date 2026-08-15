import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/app/app_data_grid.dart';
import 'package:app_expedicao/src/app/app_color.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_consulta_model.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';

class CarrinhosAgruparGridController extends GetxController {
  static const gridName = 'carrinhosAgrouparGrid';
  final iconSize = 19.0;

  final DataGridController dataGridController = DataGridController();
  final gridFocusNode = FocusNode();
  late final List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel> _itens = [];

  List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel> get itens => _itens;

  String? highlightedItem;
  bool _applyingSelection = false;
  bool get applyingSelection => _applyingSelection;


  void Function(ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel item)?
      onPressedGroup;

  void Function(ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel item)?
      onPressedRemove;

  @override
  void onClose() {
    gridFocusNode.dispose();
    super.onClose();
  }

  void addGrid(ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel item) {
    _itens.add(item);
  }

  void addAllGrid(
      List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel> itens) {
    _itens.addAll(itens);
  }

  void updateGrid(ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel item) {
    final index = _itens.indexWhere(
        (el) => el.itemCarrinhoPercurso == item.itemCarrinhoPercurso);
    if (index == -1) return;
    _itens[index] = item;
  }

  void updateAllGrid(
      List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel> itens) {
    for (var el in itens) {
      final index = _itens
          .indexWhere((i) => i.itemCarrinhoPercurso == el.itemCarrinhoPercurso);

      if (index == -1) return;
      _itens[index] = el;
    }
  }

  void updateGridSituationItem(String item, String situacao) {
    final index = _itens.indexWhere((el) => el.itemCarrinhoPercurso == item);
    if (index == -1) return;
    _itens[index] = _itens[index].copyWith(situacao: situacao);
  }

  ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel? findCodigoBarras(
      String codigoBarras) {
    final item = _itens.firstWhereOrNull(
      (el) => el.codigoBarrasCarrinho == codigoBarras,
    );

    return item;
  }

  void removeGrid(ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel item) {
    _itens.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codCarrinho == item.codCarrinho &&
        el.itemCarrinhoPercurso == item.itemCarrinhoPercurso);

    if (highlightedItem != null &&
        !_itens.any((el) => el.itemCarrinhoPercurso == highlightedItem)) {
      highlightedItem = null;
    }
  }

  void removeAllGrid() {
    _itens.clear();
  }

  Future<void> onRemoveItem(
    CarrinhosAgruparGridSource grid,
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel item,
  ) async {
    onPressedRemove?.call(item);
  }

  void onGroupItem(
    CarrinhosAgruparGridSource grid,
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel item,
  ) {
    onPressedGroup?.call(item);
  }

  Icon iconRemove(ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel item) {
    Color color = Colors.red;

    switch (item.situacao) {
      case ExpedicaoSituacaoModel.conferido:
      case ExpedicaoSituacaoModel.cancelada:
      case ExpedicaoSituacaoModel.emEntrega:
      case ExpedicaoSituacaoModel.embalando:
        color = Colors.grey;
        break;
      case ExpedicaoSituacaoModel.agrupado:
        color = Colors.red;
        break;
    }

    return Icon(
      size: iconSize,
      Icons.delete,
      color: color,
    );
  }

  Icon iconGroup(ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel item) {
    Color color = Colors.grey;

    switch (item.situacao) {
      case ExpedicaoSituacaoModel.conferido:
        color = Colors.green;
        break;
    }

    return Icon(
      size: iconSize,
      BootstrapIcons.layers_fill,
      color: color,
    );
  }

  Widget iconIndicator(ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel item) {
    Color color = Theme.of(Get.context!).primaryColor;

    switch (item.situacao) {
      case ExpedicaoSituacaoModel.cancelada:
        return Icon(
          size: iconSize,
          BootstrapIcons.cart_x_fill,
          color: color,
        );

      case ExpedicaoSituacaoModel.conferido:
      case ExpedicaoSituacaoModel.emEntrega:
      case ExpedicaoSituacaoModel.embalando:
        return Icon(
          size: iconSize,
          BootstrapIcons.cart_check_fill,
          color: color,
        );

      case ExpedicaoSituacaoModel.conferindo:
        return Icon(
          size: iconSize,
          BootstrapIcons.cart_plus_fill,
          color: color,
        );

      default:
        return Icon(
          size: iconSize,
          BootstrapIcons.cart_fill,
          color: color,
        );
    }
  }

  int findIndexItem(String item) {
    return _itens.indexWhere((el) => el.itemCarrinhoPercurso == item);
  }

  ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel? get selectedItem {
    if (highlightedItem == null) {
      return null;
    }

    final match =
        _itens.where((el) => el.itemCarrinhoPercurso == highlightedItem);
    if (match.isEmpty) {
      return null;
    }

    return match.first;
  }

  void setSelectedRow(int index, {bool scroll = true}) {
    dataGridController.selectAndScrollToRow(
      index,
      scroll: scroll,
      rowCount: _itens.length,
    );
  }

  void highlightFirstRow() {
    if (_itens.isEmpty) {
      return;
    }

    highlightItem(_itens.first.itemCarrinhoPercurso);
  }

  void highlightAdjacentRow(int delta) {
    if (_itens.isEmpty) {
      return;
    }

    var current =
        highlightedItem == null ? -1 : findIndexItem(highlightedItem!);
    if (current < 0) {
      current = delta > 0 ? -1 : 0;
    }

    final next = (current + delta).clamp(0, _itens.length - 1);
    highlightItem(_itens[next].itemCarrinhoPercurso);
  }

  KeyEventResult handleGridKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      highlightAdjacentRow(1);
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      highlightAdjacentRow(-1);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

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

  Color rowColor(ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel item) {
    if (highlightedItem != null && item.itemCarrinhoPercurso == highlightedItem) {
      return AppColor.gridRowSelectedRowColor;
    }

    return Colors.white;
  }
}
