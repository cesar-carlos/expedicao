import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_source.dart';
import 'package:app_expedicao/src/pages/separacao/widget/separacao_dailog_widget.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_consulta_model.dart';

class SepararCarrinhoGridController extends GetxController {
  final RxList<ExpedicaoPercursoConsultaModel> _itens = RxList.empty();
  List<ExpedicaoPercursoConsultaModel> get itens => _itens;

  void addItem(ExpedicaoPercursoConsultaModel item) {
    _itens.add(item);
  }

  void removeItem(ExpedicaoPercursoConsultaModel item) {
    _itens.remove(item);
  }

  Future<void> removeItemGrid(
    SepararCarrinhoGridSource grid,
    ExpedicaoPercursoConsultaModel item,
  ) async {
    const message = 'Deseja realmente excluir?';
    const detail = 'Ao excluir o item, ele será removido do carrinho!';

    final bool? confirmation = await ConfirmationDialogWidget.show(
      context: Get.context!,
      message: message,
      detail: detail,
    );

    if (confirmation != null && confirmation) {
      removeItem(item);
    }
  }

  void editItemGrid(
    SepararCarrinhoGridSource grid,
    ExpedicaoPercursoConsultaModel item,
  ) {
    final dialog = SeparacaoDailogWidget(codCarrinho: 1);
    dialog.show();
  }

  void saveItemGrid(
    SepararCarrinhoGridSource grid,
    ExpedicaoPercursoConsultaModel item,
  ) {
    print('SALVAR CARRINHO SEPARACAO');
  }
}
