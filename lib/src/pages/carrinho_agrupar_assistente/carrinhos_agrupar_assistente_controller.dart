import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_agrupar_service.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_process_dialog_generic_widget.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar_assistente/model/carrinhos_agrupar_assistente_view_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/message_dialog/message_dialog_view.dart';

class CarrinhosAgruparAssistenteController extends GetxController {
  String descricaoCarrinho = '';
  String situacaoCarrinho = '';
  String estagioCarrinho = '';
  String setorEstoque = '';

  late FocusNode formFocusNode;
  late FocusNode focusNodeCodigoCarrinho;
  late FocusNode focusNodeButtonContinuar;

  late TextEditingController controllerCodigoCarrinho;

  late CarrinhosAgruparAssistenteViewModel input;

  ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel?
      _carrinhoPercursoAgrupamentoConsulta;

  CarrinhosAgruparAssistenteController(this.input);

  String get title => 'Assistente de Agrupamento';

  @override
  void onInit() {
    formFocusNode = FocusNode();
    focusNodeCodigoCarrinho = FocusNode();
    controllerCodigoCarrinho = TextEditingController();
    focusNodeButtonContinuar = FocusNode();
    super.onInit();
  }

  @override
  void onClose() {
    formFocusNode.dispose();
    focusNodeCodigoCarrinho.dispose();
    controllerCodigoCarrinho.dispose();
    focusNodeButtonContinuar.dispose();
    super.onClose();
  }

  KeyEventResult handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        Get.find<AppEventState>()..canCloseWindow = true;
        Get.back();

        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  Future<void> fillFormFromExpedicaoCarrinhoPercursoAgrupamentoConsultaModel(
      ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel model) async {
    descricaoCarrinho = model.nomeCarrinho;
    situacaoCarrinho = model.situacao;
    estagioCarrinho = model.descricaoPercursoEstagio ?? '';
    //setorEstoque = model.nomeSetorEstoque ?? '';

    _carrinhoPercursoAgrupamentoConsulta = model;
    update();

    await Future.delayed(Duration(milliseconds: 100));
  }

  void formClear() {
    descricaoCarrinho = '';
    situacaoCarrinho = '';
    estagioCarrinho = '';
    setorEstoque = '';

    controllerCodigoCarrinho.clear();
    focusNodeCodigoCarrinho.requestFocus();
    update();
  }

  Future<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel?> faindCart(
      String codigoCarrinho) async {
    return await LoadingProcessDialogGenericWidget.show<
        ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel?>(
      context: Get.context!,
      process: () async {
        try {
          final params = '''
            CodEmpresa = ${input.codEmpresa}
              AND Origem = '${input.origem}'
              AND CodOrigem = ${input.codOrigem} 
              AND CodigoBarrasCarrinho LIKE '${codigoCarrinho.trim()}' ''';

          final result =
              await CarrinhoPercursoEstagioAgruparService.consulta(params);

          if (result.isEmpty) return null;
          return result.first;
        } catch (err) {
          return null;
        }
      },
    );
  }

  Future<bool> validAddCart(
      ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel? model) async {
    if (model == null) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não encontrado.',
        detail:
            'Carrinho não encontrado. Verifique o código do carrinho e tente novamente.',
      );

      return false;
    }

    if (model.situacao != ExpedicaoSituacaoModel.conferido) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não disponível',
        detail: 'O carrinho informado com situacao ${model.situacao}.',
      );

      return false;
    }

    return true;
  }

  void onChangedCodigoCarrinho(String text) async {}

  void onSubmittedCodigoCarrinho(String text) async {
    final result = await faindCart(text);
    final isValid = await validAddCart(result);

    if (isValid) {
      await fillFormFromExpedicaoCarrinhoPercursoAgrupamentoConsultaModel(
          result!);
      focusNodeButtonContinuar.requestFocus();
    } else {
      formClear();
    }
  }

  void onPressedCloseBar() {
    Get.find<AppEventState>()..canCloseWindow = true;
    Get.back(result: null);
  }

  void onPressedCancelar() {
    Get.find<AppEventState>()..canCloseWindow = true;
    Get.back(result: null);
  }

  void onPressedContinuar() {
    if (_carrinhoPercursoAgrupamentoConsulta == null) {
      MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não encontrado.',
        detail:
            'Carrinho não encontrado. Verifique o código do carrinho e tente novamente.',
      );

      return;
    }

    Get.find<AppEventState>()..canCloseWindow = true;
    Get.back(result: _carrinhoPercursoAgrupamentoConsulta);
  }
}
