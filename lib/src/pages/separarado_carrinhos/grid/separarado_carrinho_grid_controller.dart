import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/service/separacao_carrinho_validacao.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/grid/separarado_carrinho_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/app/app_color.dart';
import 'package:app_expedicao/src/app/app_data_grid.dart';

class SeparadoCarrinhoGridController extends GetxController {
  static const gridName = 'separadoCarrinhoGrid';

  final iconSize = 19.0;
  final DataGridController dataGridController = DataGridController();
  final gridFocusNode = FocusNode();
  late final List<ExpedicaoCarrinhoPercursoEstagioConsultaModel> _itens = [];

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
  onPressedSave;

  void Function(ExpedicaoCarrinhoPercursoEstagioConsultaModel item)?
  onPressedReopen;

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
    if (index < 0) {
      return;
    }
    _itens[index] = item;
  }

  void updateAllGrid(
    List<ExpedicaoCarrinhoPercursoEstagioConsultaModel> itens,
  ) {
    for (var el in itens) {
      final index = _itens.indexWhere((i) => i.item == el.item);
      _itens[index] = el;
    }
  }

  void removeGrid(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    _itens.removeWhere(
      (el) =>
          el.codEmpresa == item.codEmpresa &&
          el.codCarrinho == item.codCarrinho &&
          el.item == item.item,
    );
  }

  void removeAllGrid() {
    _itens.clear();
  }

  Future<void> onRemoveItem(
    SeparadoCarrinhoGridSource grid,
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    onPressedRemove?.call(item);
  }

  void onEditItem(
    SeparadoCarrinhoGridSource grid,
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) {
    onPressedEdit?.call(item);
  }

  Future<void> onSavetem(
    SeparadoCarrinhoGridSource grid,
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    onPressedSave?.call(item);
  }

  Future<void> onReopenItem(
    SeparadoCarrinhoGridSource grid,
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    onPressedReopen?.call(item);
  }

  Icon iconIndicator(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    return Icon(
      BootstrapIcons.file_earmark_arrow_down_fill,
      color: Theme.of(Get.context!).primaryColor,
      size: iconSize,
    );
  }

  bool canRemove(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    return item.situacao != ExpedicaoSituacaoModel.cancelada &&
        item.situacao != ExpedicaoSituacaoModel.separado;
  }

  bool canSave(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    return item.situacao != ExpedicaoSituacaoModel.cancelada &&
        item.situacao != ExpedicaoSituacaoModel.separado;
  }

  bool canReopen(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    if (!Get.isRegistered<ExpedicaoSepararConsultaModel>()) {
      return false;
    }

    return SeparacaoCarrinhoValidacao.podeReabrir(
      situacaoSeparacao: Get.find<ExpedicaoSepararConsultaModel>().situacao,
      situacaoCarrinho: item.situacao,
    );
  }

  Icon iconRemove(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    return Icon(
      size: iconSize,
      Icons.delete,
      color: canRemove(item) ? Colors.red : Colors.grey,
    );
  }

  Icon iconEdit(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    Color color = Colors.blue;

    switch (item.situacao) {
      case ExpedicaoSituacaoModel.cancelada:
        color = Colors.red;
      case ExpedicaoSituacaoModel.separando:
        color = Colors.lightBlue;
      case ExpedicaoSituacaoModel.separado:
        color = Colors.green;
    }

    return Icon(
      size: iconSize,
      item.situacao != ExpedicaoSituacaoModel.cancelada &&
              item.situacao != ExpedicaoSituacaoModel.separado
          ? Icons.edit
          : Icons.visibility,
      color: color,
    );
  }

  Icon iconSave(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    if (canReopen(item)) {
      return Icon(size: iconSize, Icons.lock_open, color: Colors.orange);
    }

    return Icon(
      size: iconSize,
      Icons.save,
      color: canSave(item) ? Colors.green : Colors.grey,
    );
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

    var current = highlightedItem == null
        ? -1
        : findIndexItem(highlightedItem!);
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
