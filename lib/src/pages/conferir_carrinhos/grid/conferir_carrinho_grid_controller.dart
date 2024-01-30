import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/grid/conferir_carrinho_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_conferir_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';

class ConferirCarrinhoGridController extends GetxController {
  static const gridName = 'conferirCarrinhoGrid';

  final DataGridController dataGridController = DataGridController();
  late List<ExpedicaoCarrinhoConferirConsultaModel> _itens = [];

  List<ExpedicaoCarrinhoConferirConsultaModel> get itens => _itens;
  List<ExpedicaoCarrinhoConferirConsultaModel> get itensSort => _itens.toList()
    ..sort((a, b) => b.itemCarrinhoPercurso.compareTo(a.itemCarrinhoPercurso));

  @override
  void onInit() {
    super.onInit();
  }

  void Function(ExpedicaoCarrinhoConferirConsultaModel item)? onPressedRemove;
  void Function(ExpedicaoCarrinhoConferirConsultaModel item)? onPressedSave;

  void addGrid(ExpedicaoCarrinhoConferirConsultaModel item) {
    _itens.add(item);
  }

  void addAllGrid(List<ExpedicaoCarrinhoConferirConsultaModel> itens) {
    _itens.addAll(itens);
  }

  void updateGrid(ExpedicaoCarrinhoConferirConsultaModel item) {
    final index = _itens.indexWhere(
        (el) => el.itemCarrinhoPercurso == item.itemCarrinhoPercurso);
    _itens[index] = item;
  }

  void updateAllGrid(List<ExpedicaoCarrinhoConferirConsultaModel> itens) {
    for (var el in itens) {
      final index = _itens
          .indexWhere((i) => i.itemCarrinhoPercurso == el.itemCarrinhoPercurso);
      _itens[index] = el;
    }
  }

  void updateGridSituationCarrinho(int codCarrinho, String situacao) {
    for (var el in _itens) {
      if (el.codCarrinho == codCarrinho) {
        el.situacaoCarrinho = situacao;
      }
    }
  }

  void removeGrid(ExpedicaoCarrinhoConferirConsultaModel item) {
    _itens.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codCarrinho == item.codCarrinho &&
        el.itemCarrinhoPercurso == item.itemCarrinhoPercurso);
  }

  void removeAllGrid() {
    _itens.clear();
  }

  void editGrid(
    ConferirCarrinhoGridSource carrinhoGrid,
    ExpedicaoCarrinhoConferirConsultaModel percursoEstagioConsulta,
  ) {
    //TODO: implementar
  }

  Future<void> onRemoveItem(
    ConferirCarrinhoGridSource grid,
    ExpedicaoCarrinhoConferirConsultaModel item,
  ) async {
    if (item.situacao == ExpedicaoSituacaoModel.cancelada) {
      await ConfirmationDialogMessageWidget.show(
        canCloseWindow: false,
        context: Get.context!,
        message: 'Carrinho já cancelado!',
        detail: 'Não é possível cancelar um carrinho já cancelado!',
      );

      return;
    }

    if (item.situacao == ExpedicaoSituacaoModel.separando) {
      await ConfirmationDialogMessageWidget.show(
        canCloseWindow: false,
        context: Get.context!,
        message: 'Carrinho já finalizado!',
        detail: 'Não é possível cancelar um carrinho já finalizado!',
      );

      return;
    }

    final bool? confirmation = await ConfirmationDialogWidget.show(
      canCloseWindow: false,
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
        canCloseWindow: false,
        context: Get.context!,
        message: 'Carrinho já cancelado!',
        detail: 'Não é possível salva um carrinho que esteja cancelado!',
      );

      return;
    }

    if (item.situacao == ExpedicaoSituacaoModel.separando) {
      await ConfirmationDialogMessageWidget.show(
        canCloseWindow: false,
        context: Get.context!,
        message: 'Carrinho já finalizado!',
        detail: 'Não é possível salva um carrinho que esteja finalizado!',
      );

      return;
    }

    final bool? confirmation = await ConfirmationDialogWidget.show(
      canCloseWindow: false,
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
      size: 19,
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
      size: 19,
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
      size: 19,
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
    if (item.situacaoCarrinho == ExpedicaoSituacaoModel.conferido) {
      return const Icon(
        BootstrapIcons.check_circle_fill,
        color: Colors.green,
        size: 19,
      );
    }

    return Icon(
      BootstrapIcons.cart_fill,
      color: Theme.of(Get.context!).primaryColor,
      size: 19,
    );
  }
}
