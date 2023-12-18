import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/grid/separarado_carrinho_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';

class SeparadoCarrinhoGridController extends GetxController {
  static const gridName = 'separadoCarrinhoGrid';
  final DataGridController dataGridController = DataGridController();
  late List<ExpedicaoCarrinhoPercursoConsultaModel> _itensGrid;

  List<ExpedicaoCarrinhoPercursoConsultaModel> get itens => _itensGrid;
  List<ExpedicaoCarrinhoPercursoConsultaModel> get itensSort =>
      _itensGrid.toList()..sort((a, b) => b.item.compareTo(a.item));

  @override
  void onInit() {
    super.onInit();

    _itensGrid = [];
  }

  void Function(ExpedicaoCarrinhoPercursoConsultaModel item)? onPressedEdit;
  void Function(ExpedicaoCarrinhoPercursoConsultaModel item)? onPressedRemove;
  void Function(ExpedicaoCarrinhoPercursoConsultaModel item)? onPressedSave;

  void addGrid(ExpedicaoCarrinhoPercursoConsultaModel item) {
    _itensGrid.add(item);
  }

  void addAllGrid(List<ExpedicaoCarrinhoPercursoConsultaModel> itens) {
    _itensGrid.addAll(itens);
  }

  void updateGrid(ExpedicaoCarrinhoPercursoConsultaModel item) {
    final index = _itensGrid.indexWhere((el) => el.item == item.item);
    _itensGrid[index] = item;
  }

  void updateAllGrid(List<ExpedicaoCarrinhoPercursoConsultaModel> itens) {
    for (var el in itens) {
      final index = _itensGrid.indexWhere((i) => i.item == el.item);
      _itensGrid[index] = el;
    }
  }

  void removeGrid(ExpedicaoCarrinhoPercursoConsultaModel item) {
    _itensGrid.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codCarrinho == item.codCarrinho &&
        el.item == item.item);
  }

  void removeAllGrid() {
    _itensGrid.clear();
  }

  void editGrid(
    SeparadoCarrinhoGridSource grid,
    ExpedicaoCarrinhoPercursoConsultaModel item,
  ) {
    onPressedEdit?.call(item);
  }

  Future<void> onRemoveItem(
    SeparadoCarrinhoGridSource grid,
    ExpedicaoCarrinhoPercursoConsultaModel item,
  ) async {
    onPressedRemove?.call(item);
  }

  Future<void> onSavetem(
    SeparadoCarrinhoGridSource grid,
    ExpedicaoCarrinhoPercursoConsultaModel item,
  ) async {
    onPressedSave?.call(item);
  }

  Icon iconEdit(ExpedicaoCarrinhoPercursoConsultaModel item) {
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
      size: 17,
      item.situacao != ExpedicaoSituacaoModel.cancelada &&
              item.situacao != ExpedicaoSituacaoModel.separado
          ? Icons.edit
          : Icons.visibility,
      color: color,
    );
  }

  Icon iconRemove(ExpedicaoCarrinhoPercursoConsultaModel item) {
    Color color = Colors.red;

    switch (item.situacao) {
      case ExpedicaoSituacaoModel.cancelada:
        color = Colors.grey;
      case ExpedicaoSituacaoModel.separando:
        color = Colors.lightBlue;
      case ExpedicaoSituacaoModel.separado:
        color = Colors.grey;
    }

    return Icon(
      size: 17,
      Icons.delete,
      color: color,
    );
  }

  Icon iconSave(ExpedicaoCarrinhoPercursoConsultaModel item) {
    Color color = Colors.blue;

    switch (item.situacao) {
      case ExpedicaoSituacaoModel.cancelada:
        color = Colors.grey;
      case ExpedicaoSituacaoModel.separando:
        color = Colors.green;
      case ExpedicaoSituacaoModel.separado:
        color = Colors.grey;
      case ExpedicaoSituacaoModel.emAndamento:
        color = Colors.green;
    }

    return Icon(
      size: 17,
      Icons.save,
      color: color,
    );
  }

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
}
