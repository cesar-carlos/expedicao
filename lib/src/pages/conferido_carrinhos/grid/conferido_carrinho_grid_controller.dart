import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/app/app_data_grid.dart';
import 'package:app_expedicao/src/app/app_color.dart';
import 'package:app_expedicao/src/pages/conferido_carrinhos/grid/conferido_carrinho_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';

class ConferidoCarrinhoGridController extends GetxController {
  static const gridName = 'conferidoCarrinhoGrid';
  final iconSize = 19.0;

  final dataGridController = DataGridController();
  final gridFocusNode = FocusNode();
  final List<ExpedicaoCarrinhoPercursoEstagioConsultaModel> _itens = [];

  List<ExpedicaoCarrinhoPercursoEstagioConsultaModel> get itens => _itens;
  List<ExpedicaoCarrinhoPercursoEstagioConsultaModel> get itensSort =>
      _itens.toList()..sort((a, b) => b.item.compareTo(a.item));

  String? highlightedItem;
  bool _applyingSelection = false;
  bool get applyingSelection => _applyingSelection;

  void Function(ExpedicaoCarrinhoPercursoEstagioConsultaModel item)?
      onPressedRemove;

  void Function(ExpedicaoCarrinhoPercursoEstagioConsultaModel item)?
      onPressedEdit;

  void Function(ExpedicaoCarrinhoPercursoEstagioConsultaModel item)?
      onPressedGroup;

  void Function(ExpedicaoCarrinhoPercursoEstagioConsultaModel item)?
      onPressedSave;

  @override
  void onClose() {
    gridFocusNode.dispose();
    super.onClose();
  }

  void addGrid(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    _itens.add(item);
  }

  void addAllGrid(List<ExpedicaoCarrinhoPercursoEstagioConsultaModel> itens) {
    _itens.addAll(itens);
  }

  void updateGrid(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    final index = _itens.indexWhere((el) => el.item == item.item);
    if (index == -1) return;
    _itens[index] = item;
  }

  void updateAllGrid(
      List<ExpedicaoCarrinhoPercursoEstagioConsultaModel> itens) {
    for (var el in itens) {
      final index = _itens.indexWhere((i) => i.item == el.item);
      if (index == -1) return;
      _itens[index] = el;
    }
  }

  void updateGridSituationItem(String item, String situacao) {
    final index = _itens.indexWhere((el) => el.item == item);
    if (index == -1) return;
    _itens[index] = _itens[index].copyWith(situacao: situacao);
  }

  void removeGrid(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    _itens.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codCarrinho == item.codCarrinho &&
        el.item == item.item);

    if (highlightedItem != null &&
        !_itens.any((el) => el.item == highlightedItem)) {
      highlightedItem = null;
    }
  }

  void removeAllGrid() {
    _itens.clear();
  }

  Future<void> onRemoveItem(
    ConferidoCarrinhoGridSource grid,
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    onPressedRemove?.call(item);
  }

  void onEditItem(
    ConferidoCarrinhoGridSource grid,
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) {
    onPressedEdit?.call(item);
  }

  Future<void> onGrouptem(
    ConferidoCarrinhoGridSource grid,
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    onPressedGroup?.call(item);
  }

  Future<void> onSavetem(
    ConferidoCarrinhoGridSource grid,
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    onPressedSave?.call(item);
  }

  Icon iconRemove(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    Color color = Colors.red;

    switch (item.situacao) {
      case ExpedicaoSituacaoModel.conferido:
      case ExpedicaoSituacaoModel.cancelada:
      case ExpedicaoSituacaoModel.agrupado:
      case ExpedicaoSituacaoModel.emEntrega:
      case ExpedicaoSituacaoModel.embalando:
        color = Colors.grey;
        break;
    }

    return Icon(
      size: iconSize,
      Icons.delete,
      color: color,
    );
  }

  Icon iconEdit(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    Color color = Colors.blue;

    bool isViewIcon = [
      ExpedicaoSituacaoModel.conferido,
      ExpedicaoSituacaoModel.cancelada,
      ExpedicaoSituacaoModel.agrupado,
      ExpedicaoSituacaoModel.emEntrega,
      ExpedicaoSituacaoModel.embalando
    ].contains(item.situacao);

    switch (item.situacao) {
      case ExpedicaoSituacaoModel.cancelada:
        color = Colors.red;
        break;
      case ExpedicaoSituacaoModel.conferido:
      case ExpedicaoSituacaoModel.agrupado:
        color = Colors.green;
        break;
    }

    return Icon(
      size: iconSize,
      !isViewIcon ? Icons.edit : Icons.visibility,
      color: color,
    );
  }

  Icon iconGroup(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    Color color = Colors.transparent;

    switch (item.situacao) {
      case ExpedicaoSituacaoModel.conferindo:
      case ExpedicaoSituacaoModel.cancelada:
      case ExpedicaoSituacaoModel.agrupado:
      case ExpedicaoSituacaoModel.emEntrega:
      case ExpedicaoSituacaoModel.embalando:
        color = Colors.grey;
        break;
      case ExpedicaoSituacaoModel.conferido:
        color = Colors.blue;
        break;
    }

    return Icon(
      size: iconSize - 1.0,
      BootstrapIcons.save2_fill,
      color: color,
    );
  }

  Icon iconSave(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    Color color = Colors.blue;

    switch (item.situacao) {
      case ExpedicaoSituacaoModel.conferido:
      case ExpedicaoSituacaoModel.cancelada:
      case ExpedicaoSituacaoModel.agrupado:
      case ExpedicaoSituacaoModel.emEntrega:
      case ExpedicaoSituacaoModel.embalando:
        color = Colors.grey;
        break;
    }

    return Icon(
      size: iconSize,
      Icons.save,
      color: color,
    );
  }

  Widget iconIndicator(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
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
    return itensSort.indexWhere((el) => el.item == item);
  }

  ExpedicaoCarrinhoPercursoEstagioConsultaModel? get selectedItem {
    if (highlightedItem == null) {
      return null;
    }

    final match = itensSort.where((el) => el.item == highlightedItem);
    if (match.isEmpty) {
      return null;
    }

    return match.first;
  }

  void setSelectedRow(int index, {bool scroll = true}) {
    dataGridController.selectAndScrollToRow(
      index,
      scroll: scroll,
      rowCount: itensSort.length,
    );
  }

  void highlightFirstRow() {
    if (itensSort.isEmpty) {
      return;
    }

    highlightItem(itensSort.first.item);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (gridFocusNode.canRequestFocus) {
        gridFocusNode.requestFocus();
      }
    });
  }

  void highlightAdjacentRow(int delta) {
    final itens = itensSort;
    if (itens.isEmpty) {
      return;
    }

    var current =
        highlightedItem == null ? -1 : findIndexItem(highlightedItem!);
    if (current < 0) {
      current = delta > 0 ? -1 : 0;
    }

    final next = (current + delta).clamp(0, itens.length - 1);
    highlightItem(itens[next].item);
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

  Color rowColor(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    if (highlightedItem != null && item.item == highlightedItem) {
      return AppColor.gridRowSelectedRowColor;
    }

    return Colors.white;
  }
}
