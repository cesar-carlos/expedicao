import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/separacao/separacao_page.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SepararCarrinhoGridController extends GetxController {
  final RxList<ExpedicaoCarrinhoPercursoConsultaModel> _itens = RxList.empty();
  final dataGridController = DataGridController();

  List<ExpedicaoCarrinhoPercursoConsultaModel> get itens => _itens;
  List<ExpedicaoCarrinhoPercursoConsultaModel> get itensSort =>
      _itens.toList()..sort((a, b) => b.item.compareTo(a.item));

  void Function(ExpedicaoCarrinhoPercursoConsultaModel item)?
      onPressedRemoveItem;

  void addItem(ExpedicaoCarrinhoPercursoConsultaModel item) {
    _itens.add(item);
  }

  void removeItem(ExpedicaoCarrinhoPercursoConsultaModel item) {
    _itens.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codCarrinho == item.codCarrinho &&
        el.item == item.item);
  }

  void updateItem(ExpedicaoCarrinhoPercursoConsultaModel item) {
    final index = _itens.indexWhere(
        (el) => el.item == item.item && el.codCarrinho == item.codCarrinho);
    if (index == -1) return;
    _itens[index] = item;
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
    SepararCarrinhoGridSource carrinhoGrid,
    ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta,
  ) {
    final dialog = SeparacaoPage(percursoEstagioConsulta);
    dialog.show();
  }

  void saveItemGrid(
    SepararCarrinhoGridSource carrinhoGrid,
    ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta,
  ) {
    print('SALVAR CARRINHO SEPARACAO');
  }
}
