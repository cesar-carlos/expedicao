import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/pages/separacao/separacao_page.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';

class SepararCarrinhoGridController extends GetxController {
  static const gridName = 'separarCarrinhoGrid';
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
    SepararCarrinhoGridSource carrinhoGrid,
    ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta,
  ) {
    final dialog = SeparacaoPage(percursoEstagioConsulta);
    dialog.show();
  }

  Future<void> onRemoveItem(
    SepararCarrinhoGridSource grid,
    ExpedicaoCarrinhoPercursoConsultaModel item,
  ) async {
    if (item.situacao == ExpedicaoSituacaoModel.cancelada) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Carrinho já cancelado!',
        detail: 'Não é possível cancelar um carrinho já cancelado!',
      );

      return;
    }

    if (item.situacao == ExpedicaoSituacaoModel.finalizada) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Carrinho já finalizado!',
        detail: 'Não é possível cancelar um carrinho já finalizado!',
      );

      return;
    }

    final bool? confirmation = await ConfirmationDialogWidget.show(
      context: Get.context!,
      message: 'Deseja realmente cancelar?',
      detail: 'Ao cancelar, os itens serão removido do carrinho!',
    );

    if (confirmation != null && confirmation) {
      onPressedRemove?.call(item);
    }
  }

  Future<void> onSavetem(
    SepararCarrinhoGridSource grid,
    ExpedicaoCarrinhoPercursoConsultaModel item,
  ) async {
    if (item.situacao == ExpedicaoSituacaoModel.cancelada) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Carrinho já cancelado!',
        detail: 'Não é possível salva um carrinho que esteja cancelado!',
      );

      return;
    }

    if (item.situacao == ExpedicaoSituacaoModel.finalizada) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Carrinho já finalizado!',
        detail: 'Não é possível salva um carrinho que esteja finalizado!',
      );

      return;
    }

    final bool? confirmation = await ConfirmationDialogWidget.show(
      context: Get.context!,
      message: 'Deseja Salva?',
      detail: 'Ao salvar, o carrinho não podera ser mais alterado!',
    );

    if (confirmation != null && confirmation) {
      onPressedSave?.call(item);
    }
  }

  Icon iconEdit(ExpedicaoCarrinhoPercursoConsultaModel item) {
    return Icon(
      size: 17,
      item.situacao != ExpedicaoSituacaoModel.cancelada &&
              item.situacao != ExpedicaoSituacaoModel.finalizada
          ? Icons.edit
          : Icons.visibility,
      color: Colors.blue,
    );
  }

  Icon iconRemove(ExpedicaoCarrinhoPercursoConsultaModel item) {
    return Icon(
      size: 17,
      Icons.delete,
      color: item.situacao != ExpedicaoSituacaoModel.cancelada &&
              item.situacao != ExpedicaoSituacaoModel.finalizada
          ? Colors.red
          : Colors.grey,
    );
  }

  Icon iconSave(ExpedicaoCarrinhoPercursoConsultaModel item) {
    return Icon(
      size: 17,
      Icons.save,
      color: item.situacao == ExpedicaoSituacaoModel.finalizada
          ? Colors.green
          : Colors.blue,
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
