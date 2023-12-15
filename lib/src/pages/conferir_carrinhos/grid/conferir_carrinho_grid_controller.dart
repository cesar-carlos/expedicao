import 'package:app_expedicao/src/pages/common/widget/alert_animation_icon_widget.dart';
import 'package:app_expedicao/src/pages/common/widget/box_animation_icon_widget.dart';
import 'package:app_expedicao/src/pages/common/widget/complit_animation_icon_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/grid/conferir_carrinho_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_conferir_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';

class ConferirCarrinhoGridController extends GetxController {
  static const gridName = 'conferirCarrinhoGrid';
  final DataGridController dataGridController = DataGridController();
  late List<ExpedicaoCarrinhoConferirConsultaModel> _itensGrid;

  List<ExpedicaoCarrinhoConferirConsultaModel> get itens => _itensGrid;
  List<ExpedicaoCarrinhoConferirConsultaModel> get itensSort => _itensGrid
      .toList()
    ..sort((a, b) => b.itemCarrinhoPercurso.compareTo(a.itemCarrinhoPercurso));

  @override
  void onInit() {
    super.onInit();

    _itensGrid = [];
  }

  void Function(ExpedicaoCarrinhoConferirConsultaModel item)? onPressedRemove;
  void Function(ExpedicaoCarrinhoConferirConsultaModel item)? onPressedSave;

  void addGrid(ExpedicaoCarrinhoConferirConsultaModel item) {
    _itensGrid.add(item);
  }

  void addAllGrid(List<ExpedicaoCarrinhoConferirConsultaModel> itens) {
    _itensGrid.addAll(itens);
  }

  void updateGrid(ExpedicaoCarrinhoConferirConsultaModel item) {
    final index = _itensGrid.indexWhere(
        (el) => el.itemCarrinhoPercurso == item.itemCarrinhoPercurso);
    _itensGrid[index] = item;
  }

  void updateAllGrid(List<ExpedicaoCarrinhoConferirConsultaModel> itens) {
    for (var el in itens) {
      final index = _itensGrid
          .indexWhere((i) => i.itemCarrinhoPercurso == el.itemCarrinhoPercurso);
      _itensGrid[index] = el;
    }
  }

  void updateGridSituationCarrinho(int codCarrinho, String situacao) {
    for (var el in _itensGrid) {
      if (el.codCarrinho == codCarrinho) {
        el.situacaoCarrinho = situacao;
      }
    }
  }

  void removeGrid(ExpedicaoCarrinhoConferirConsultaModel item) {
    _itensGrid.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codCarrinho == item.codCarrinho &&
        el.itemCarrinhoPercurso == item.itemCarrinhoPercurso);
  }

  void removeAllGrid() {
    _itensGrid.clear();
  }

  void editGrid(
    ConferirCarrinhoGridSource carrinhoGrid,
    ExpedicaoCarrinhoConferirConsultaModel percursoEstagioConsulta,
  ) {
    // final dialog = SeparacaoPage(percursoEstagioConsulta);
    // dialog.show();
  }

  Future<void> onRemoveItem(
    ConferirCarrinhoGridSource grid,
    ExpedicaoCarrinhoConferirConsultaModel item,
  ) async {
    if (item.situacao == ExpedicaoSituacaoModel.cancelada) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Carrinho já cancelado!',
        detail: 'Não é possível cancelar um carrinho já cancelado!',
      );

      return;
    }

    if (item.situacao == ExpedicaoSituacaoModel.separando) {
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
    ConferirCarrinhoGridSource grid,
    ExpedicaoCarrinhoConferirConsultaModel item,
  ) async {
    if (item.situacao == ExpedicaoSituacaoModel.cancelada) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Carrinho já cancelado!',
        detail: 'Não é possível salva um carrinho que esteja cancelado!',
      );

      return;
    }

    if (item.situacao == ExpedicaoSituacaoModel.separando) {
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

  Icon iconEdit(ExpedicaoCarrinhoConferirConsultaModel item) {
    Color color = Colors.blue;

    switch (item.situacao) {
      case ExpedicaoSituacaoModel.cancelada:
        color = Colors.red;
      case ExpedicaoSituacaoModel.separando:
        color = Colors.green;
    }

    return Icon(
      size: 17,
      item.situacao != ExpedicaoSituacaoModel.cancelada &&
              item.situacao != ExpedicaoSituacaoModel.separando
          ? Icons.edit
          : Icons.visibility,
      color: color,
    );
  }

  Icon iconRemove(ExpedicaoCarrinhoConferirConsultaModel item) {
    Color color = Colors.red;

    switch (item.situacao) {
      case ExpedicaoSituacaoModel.cancelada:
        color = Colors.grey;
      case ExpedicaoSituacaoModel.separando:
        color = Colors.grey;
    }

    return Icon(
      size: 17,
      Icons.delete,
      color: color,
    );
  }

  Icon iconSave(ExpedicaoCarrinhoConferirConsultaModel item) {
    Color color = Colors.blue;

    switch (item.situacao) {
      case ExpedicaoSituacaoModel.cancelada:
        color = Colors.grey;
      case ExpedicaoSituacaoModel.separando:
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

  iconIndicator(ExpedicaoCarrinhoConferirConsultaModel item) {
    // if (item.quantidade == item.quantidadeConferida) {
    //   return const ComplitAnimationIconWidget();
    // }

    // if (item.quantidade < item.quantidadeConferida) {
    //   return const AlertAnimationIconWidget();
    // }

    return const BoxAnimationIconWidget();
  }
}
