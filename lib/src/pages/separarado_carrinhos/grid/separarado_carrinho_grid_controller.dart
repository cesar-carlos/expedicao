import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/grid/separarado_carrinho_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';

class SeparadoCarrinhoGridController extends GetxController {
  static const gridName = 'separadoCarrinhoGrid';

  final iconSize = 19.0;
  final DataGridController dataGridController = DataGridController();
  late List<ExpedicaoCarrinhoPercursoEstagioConsultaModel> _itens = [];

  List<ExpedicaoCarrinhoPercursoEstagioConsultaModel> get itens => _itens;
  List<ExpedicaoCarrinhoPercursoEstagioConsultaModel> get itensSort =>
      _itens.toList()..sort((a, b) => b.item.compareTo(a.item));

  @override
  void onInit() {
    super.onInit();
  }

  void Function(ExpedicaoCarrinhoPercursoEstagioConsultaModel item)?
      onPressedEdit;
  void Function(ExpedicaoCarrinhoPercursoEstagioConsultaModel item)?
      onPressedRemove;
  void Function(ExpedicaoCarrinhoPercursoEstagioConsultaModel item)?
      onPressedSave;

  void addGrid(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    _itens.add(item);
  }

  void addAllGrid(List<ExpedicaoCarrinhoPercursoEstagioConsultaModel> itens) {
    _itens.addAll(itens);
  }

  void updateGrid(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    final index = _itens.indexWhere((el) => el.item == item.item);
    _itens[index] = item;
  }

  void updateAllGrid(
      List<ExpedicaoCarrinhoPercursoEstagioConsultaModel> itens) {
    for (var el in itens) {
      final index = _itens.indexWhere((i) => i.item == el.item);
      _itens[index] = el;
    }
  }

  void removeGrid(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    _itens.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codCarrinho == item.codCarrinho &&
        el.item == item.item);
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

  iconIndicator(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    return Icon(
      BootstrapIcons.file_earmark_arrow_down_fill,
      color: Theme.of(Get.context!).primaryColor,
      size: iconSize,
    );
  }

  Icon iconRemove(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    Color color = Colors.red;

    switch (item.situacao) {
      case ExpedicaoSituacaoModel.cancelada:
        color = Colors.grey;
      case ExpedicaoSituacaoModel.separado:
        color = Colors.grey;
      default:
        color = Colors.red;
    }

    return Icon(
      size: iconSize,
      Icons.delete,
      color: color,
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
      size: iconSize,
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
