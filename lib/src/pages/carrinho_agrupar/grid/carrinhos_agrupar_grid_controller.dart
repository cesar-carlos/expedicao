import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';

class CarrinhosAgruparGridController extends GetxController {
  static const gridName = 'carrinhosAgrouparGrid';
  final iconSize = 19.0;

  final DataGridController dataGridController = DataGridController();
  late List<ExpedicaoCarrinhoPercursoEstagioConsultaModel> _itens = [];

  List<ExpedicaoCarrinhoPercursoEstagioConsultaModel> get itens => _itens;

  @override
  void onInit() {
    super.onInit();
  }

  void Function(ExpedicaoCarrinhoPercursoEstagioConsultaModel item)?
      onPressedGroup;
  void Function(ExpedicaoCarrinhoPercursoEstagioConsultaModel item)?
      onPressedRemove;

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
  }

  void removeAllGrid() {
    _itens.clear();
  }

  Future<void> onRemoveItem(
    CarrinhosAgruparGridSource grid,
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    onPressedRemove?.call(item);
  }

  void onGroupItem(
    CarrinhosAgruparGridSource grid,
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) {
    onPressedGroup?.call(item);
  }

  Icon iconRemove(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    Color color = Colors.red;

    switch (item.situacao) {
      case ExpedicaoSituacaoModel.cancelada:
        color = Colors.grey;
      case ExpedicaoSituacaoModel.conferido:
        color = Colors.grey;
    }

    return Icon(
      size: iconSize,
      Icons.delete,
      color: color,
    );
  }

  Icon iconGroup(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    Color color = Colors.blue;

    switch (item.situacao) {
      case ExpedicaoSituacaoModel.cancelada:
        color = Colors.red;
      case ExpedicaoSituacaoModel.conferido:
        color = Colors.green;
    }

    return Icon(
      size: iconSize,
      BootstrapIcons.layers_fill,
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
