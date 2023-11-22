import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/service/carrinho_separacao_item_services.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_adicionar_item_service.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_services.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/service/produto_service.dart';

class SeparacaoController extends GetxController {
  final ExpedicaoPercursoEstagioConsultaModel percursoEstagioConsulta;

  late ProdutoService _produtoService;
  late TextEditingController scanController;
  late TextEditingController quantidadeController;
  late SeparacaoCarrinhoGridController _separacaoGridController;
  late CarrinhoSeparacaoItemServices _separacaoServices;
  late ProcessoExecutavelModel _processoExecutavel;
  late SepararGridController _separarGridController;
  late FocusNode quantidadeFocusNode;
  late FocusNode scanFocusNode;

  SeparacaoController(this.percursoEstagioConsulta);

  @override
  void onInit() {
    _produtoService = ProdutoService();
    scanController = TextEditingController();
    quantidadeController = TextEditingController(text: '1,000');
    _separacaoGridController = Get.find<SeparacaoCarrinhoGridController>();
    _separarGridController = Get.find<SepararGridController>();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();
    _separacaoServices = CarrinhoSeparacaoItemServices();
    scanFocusNode = FocusNode()..requestFocus();
    quantidadeFocusNode = FocusNode();
    _fillGridSeparacaoItens();
    super.onInit();
  }

  @override
  void onClose() {
    scanController.dispose();
    quantidadeController.dispose();
    quantidadeFocusNode.dispose();
    scanFocusNode.dispose();
    super.onClose();
  }

  Future<void> _fillGridSeparacaoItens() async {
    final params = '''
          CodEmpresa = ${percursoEstagioConsulta.codEmpresa} 
      AND CodSepararEstoque = '${percursoEstagioConsulta.codOrigem}' 
      AND CodCarrinhoPercurso = '${percursoEstagioConsulta.codCarrinhoPercurso}'
      AND ItemCarrinhoPercurso = '${percursoEstagioConsulta.item}'
    ''';

    final separacaoItens = await _separacaoServices.consulta(params);
    _separacaoGridController.clear();
    for (var el in separacaoItens) {
      _separacaoGridController.addItem(el);
    }
  }

  Future<void> onSubmitted(String? value) async {
    if (value != null) {
      if (!value.isNotEmpty) {
        await ConfirmationDialogMessageWidget.show(
          context: Get.context!,
          message: 'Valor invalido!',
          detail: 'Digite o codigo de barras do produto para fazer a pesquisa!',
        );

        scanFocusNode.requestFocus();
        return;
      }

      if (!_separarGridController.findFrombarcode(value.trim())) {
        await ConfirmationDialogMessageWidget.show(
          context: Get.context!,
          message: 'Produto não encontrado!',
          detail: 'Este produto não esta na lista de separação!',
        );

        scanFocusNode.requestFocus();
        scanController.clear();
        return;
      }

      final result =
          await _produtoService.consultaPorCodigoBarras(value.trim());
      if (result.left != null) {
        await ConfirmationDialogMessageWidget.show(
          context: Get.context!,
          message: result.left!.title,
          detail: result.left!.message,
        );

        scanFocusNode.requestFocus();
        scanController.clear();
        return;
      }

      if (result.right != null) {
        final carrinhosPercurso =
            await CarrinhoPercursoServices().selectPercurso(
          ''' CodEmpresa = ${_processoExecutavel.codEmpresa} 
          AND Origem = '${_processoExecutavel.origem}' 
          AND CodOrigem = ${_processoExecutavel.codOrigem}
        
        ''',
        );

        if (carrinhosPercurso.isEmpty) {
          await ConfirmationDialogMessageWidget.show(
            context: Get.context!,
            message: 'Carrinho não encontrado!',
            detail: 'Não foi encontrado nenhum carrinho para o percurso!',
          );

          scanFocusNode.requestFocus();
          scanController.clear();
          return;
        }

        final carrinhoPercursoAdicionarItemService =
            CarrinhoPercursoAdicionarItemService(
          carrinhoPercurso: carrinhosPercurso.first,
          percursoEstagioConsulta: percursoEstagioConsulta,
          processo: _processoExecutavel,
        );

        final separacaoItemConsulta =
            await carrinhoPercursoAdicionarItemService.adicionar(
          codProduto: result.right!.codProduto,
          codUnidadeMedida: result.right!.codUnidadeMedida,
          quantidade: double.parse(quantidadeController.text
              .replaceAll('.', '')
              .replaceAll(',', '.')),
        );

        if (separacaoItemConsulta == null) {
          await ConfirmationDialogMessageWidget.show(
            context: Get.context!,
            message: 'Erro ao adicionar item!',
            detail: 'Não foi possivel adicionar o item ao carrinho!',
          );

          scanFocusNode.requestFocus();
          scanController.clear();
          return;
        }

        _separacaoGridController.addItem(separacaoItemConsulta);
      }
    }
  }
}
