import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/app/app_dialog.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/pages/common/widget/message_dialog.widget.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_consulta_repository.dart';
import 'package:app_expedicao/src/pages/carrinho/view_model/carrinho_view_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_consulta_model.dart';

class CarrinhoController extends GetxController {
  final CarrinhoViewModel _carrinho = CarrinhoViewModel.empty();
  final repotory = CarrinhoConsultaRepository();

  Uuid uuid = const Uuid();

  late TextEditingController textControllerCodigoCarrinho;
  late FocusNode focusNodeBtnAdicionarCarrinho;
  late FocusNode focusNodeCodigoCarrinho;
  //late AppClientHttp httpClient;

  @override
  void onInit() {
    textControllerCodigoCarrinho = TextEditingController();
    focusNodeBtnAdicionarCarrinho = FocusNode();
    focusNodeCodigoCarrinho = FocusNode();
    super.onInit();
  }

  CarrinhoViewModel get carrinho => _carrinho;

  void onSubmittedForm(String text) async {
    addCarrinho();
  }

  void onChangedCodigoCarrinho(String text) async {}

  Future<
      ({
        ExpedicaoCarrinhoConsultaModel? carrinhoConsulta,
        AppDialog? dialog
      })?> getCarrinho(String codigoBarras) async {
    final params = "CodigoBarras = '$codigoBarras'";
    final carrinhos = await repotory.select(params);

    if (carrinhos.isEmpty) {
      final appDialog = AppDialog(
        title: 'Carrinho',
        message: 'Carrinho não encontrado',
      );

      return (carrinhoConsulta: null, dialog: appDialog);
    }

    return (carrinhoConsulta: carrinhos.first, dialog: null);
  }

  addCarrinho() async {
    final codigoBarras = textControllerCodigoCarrinho.text;
    final output = await getCarrinho(codigoBarras);

    if (output?.dialog != null) {
      await customDialog(
        Get.context!,
        title: 'Carrinho',
        message: 'Carrinho não encontrado!',
      );

      focusNodeCodigoCarrinho.requestFocus();
      clear();
      update();
      return;
    }

    viewFromCarrinhoConsulta(output!.carrinhoConsulta!);
    final valid = validCarrinho(output.carrinhoConsulta!);
    update();

    if (!valid) {
      await customDialog(
        Get.context!,
        title: 'Carrinho',
        message: 'Carrinho não está liberado!',
      );

      textControllerCodigoCarrinho.selection = TextSelection(
        baseOffset: 0,
        extentOffset: textControllerCodigoCarrinho.text.length,
      );

      focusNodeCodigoCarrinho.requestFocus();
      return;
    }

    clear();
    Get.back(result: output.carrinhoConsulta!);
  }

  viewFromCarrinhoConsulta(ExpedicaoCarrinhoConsultaModel input) {
    _carrinho.codCarrinho = input.codCarrinho;
    _carrinho.descricaoCarrinho = input.descricaoCarrinho;
    _carrinho.situacao =
        ExpedicaoCarrinhoSituacaoModel.situacao[input.situacao] ?? '';
    _carrinho.local = ExpedicaoCarrinhoOrigemModel.origem[input.origem] ?? '';
    _carrinho.setor = input.nomeSetorEstoque ?? '';
    _carrinho.observacao = '';
    _carrinho.codigoBarras = input.codigoBarras;
  }

  bool validCarrinho(ExpedicaoCarrinhoConsultaModel input) {
    if (input.situacao == 'LI') {
      return true;
    }

    return false;
  }

  void clear() {
    textControllerCodigoCarrinho.clear();
    _carrinho.clear();
  }

  @override
  void onClose() {
    textControllerCodigoCarrinho.dispose();
    focusNodeBtnAdicionarCarrinho.dispose();
    focusNodeCodigoCarrinho.dispose();
    super.onClose();
  }
}
