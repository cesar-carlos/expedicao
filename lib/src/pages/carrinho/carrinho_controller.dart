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
import 'package:app_expedicao/src/model/processo_executavel_model.dart';

class CarrinhoController extends GetxController {
  final CarrinhoViewModel _carrinho = CarrinhoViewModel.empty();
  final repotory = CarrinhoConsultaRepository();

  Uuid uuid = const Uuid();

  late ProcessoExecutavelModel _processoExecutavel;
  late TextEditingController textControllerCodigoCarrinho;
  late FocusNode focusNodeBtnAdicionarCarrinho;
  late FocusNode focusNodeCodigoCarrinho;
  //late AppClientHttp httpClient;

  @override
  void onInit() {
    super.onInit();

    _processoExecutavel = Get.find<ProcessoExecutavelModel>();
    textControllerCodigoCarrinho = TextEditingController();
    focusNodeBtnAdicionarCarrinho = FocusNode();
    focusNodeCodigoCarrinho = FocusNode();
  }

  @override
  void onClose() {
    textControllerCodigoCarrinho.dispose();
    focusNodeBtnAdicionarCarrinho.dispose();
    focusNodeCodigoCarrinho.dispose();
    super.onClose();
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
    final carrinhos = await repotory.select(
      "CodEmpresa = ${_processoExecutavel.codEmpresa} AND CodigoBarras = '$codigoBarras'",
    );

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
    _carrinho.situacao = input.situacao;
    _carrinho.local = ExpedicaoCarrinhoOrigemModel.origem[input.origem] ?? '';
    _carrinho.setor = input.nomeSetorEstoque ?? '';
    _carrinho.observacao = '';
    _carrinho.codigoBarras = input.codigoBarras;
  }

  bool validCarrinho(ExpedicaoCarrinhoConsultaModel input) {
    if (input.situacao == ExpedicaoCarrinhoSituacaoModel.liberado) {
      return true;
    }

    return false;
  }

  void clear() {
    textControllerCodigoCarrinho.clear();
    _carrinho.clear();
  }
}
