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

  Future<void> onRemoveItem(
    SepararCarrinhoGridSource grid,
    ExpedicaoPercursoEstagioConsultaModel item,
  ) async {
    const message = 'Deseja realmente excluir?';
    const detail = 'Ao excluir o item, ele será removido do carrinho!';

    final bool? confirmation = await ConfirmationDialogWidget.show(
      context: Get.context!,
      message: message,
      detail: detail,
    );

    if (confirmation != null && confirmation) {
      onPressedRemoveItem?.call(item);
      removeItem(item);
    }
  }

  void editItemGrid(
    SepararCarrinhoGridSource grid,
    ExpedicaoPercursoEstagioConsultaModel item,
  ) {
    final dialog = SeparacaoDailogWidget(codCarrinho: 1);
    dialog.show();
  }

  void saveItemGrid(
    SepararCarrinhoGridSource grid,
    ExpedicaoPercursoEstagioConsultaModel item,
  ) {
    print('SALVAR CARRINHO SEPARACAO');
  }
}
