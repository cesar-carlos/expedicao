import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/separacao/widget/separacao_dailog_widget.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_source.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_consulta_model.dart';

class SepararCarrinhoGridController extends GetxController {
  final RxList<ExpedicaoPercursoEstagioConsultaModel> _itens = RxList.empty();
  List<ExpedicaoPercursoEstagioConsultaModel> get itens => _itens;

  void Function(ExpedicaoPercursoEstagioConsultaModel item)?
      onPressedRemoveItem;

  void addItem(ExpedicaoPercursoEstagioConsultaModel item) {
    _itens.add(item);
  }

  void removeItem(ExpedicaoPercursoEstagioConsultaModel item) {
    _itens.remove(item);
  }

  void updateItem(ExpedicaoPercursoEstagioConsultaModel item) {
    final index = _itens.indexWhere((el) => el.codCarrinho == item.codCarrinho);
    if (index == -1) return;
    _itens[index] = item;
  }

  Future<void> onRemoveItem(
    SepararCarrinhoGridSource grid,
    ExpedicaoPercursoEstagioConsultaModel item,
  ) async {
    if (item.situacao == 'CA') {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Carrinho já cancelado!',
        detail: 'Não é possível cancelar um carrinho já cancelado!',
      );
      return;
    }

    final bool? confirmation = await ConfirmationDialogWidget.show(
      context: Get.context!,
      message: 'Deseja realmente cancelar?',
      detail: 'Ao cancelar, os itens serão removido do carrinho!',
    );

    if (confirmation != null && confirmation) {
      onPressedRemoveItem?.call(item);
    }
  }

  void editItemGrid(
    SepararCarrinhoGridSource grid,
    ExpedicaoPercursoEstagioConsultaModel item,
  ) {
    final dialog = SeparacaoDailogWidget(codCarrinho: item.codCarrinho);
    dialog.show();
  }

  void saveItemGrid(
    SepararCarrinhoGridSource grid,
    ExpedicaoPercursoEstagioConsultaModel item,
  ) {
    print('SALVAR CARRINHO SEPARACAO');
  }
}
