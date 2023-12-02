import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:app_expedicao/src/pages/separacao/separacao_page.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';

class SepararCarrinhoGridController extends GetxController {
  final DataGridController dataGridController = DataGridController();
  late List<ExpedicaoCarrinhoPercursoConsultaModel> _itensGrid;

  List<ExpedicaoCarrinhoPercursoConsultaModel> get itens => _itensGrid;
  List<ExpedicaoCarrinhoPercursoConsultaModel> get itensSort =>
      _itensGrid.toList()..sort((a, b) => b.item.compareTo(a.item));

  @override
  void onInit() {
    super.onInit();

    _itensGrid = [];
  }

  void Function(ExpedicaoCarrinhoPercursoConsultaModel item)?
      onPressedRemoveItem;

  void addGrid(ExpedicaoCarrinhoPercursoConsultaModel item) {
    _itensGrid.add(item);

    final index = _itensGrid.indexWhere((el) => el.item == item.item);
    setSelectedRow(index);
    update();
  }

  void addAllGrid(List<ExpedicaoCarrinhoPercursoConsultaModel> itens) {
    _itensGrid.addAll(itens);
    update();
  }

  void updateGrid(ExpedicaoCarrinhoPercursoConsultaModel item) {
    final index = _itensGrid.indexWhere((el) => el.item == item.item);
    _itensGrid[index] = item;
    setSelectedRow(index);
    update();
  }

  void updateAllGrid(List<ExpedicaoCarrinhoPercursoConsultaModel> itens) {
    for (var el in itens) {
      final index = _itensGrid.indexWhere((i) => i.item == el.item);
      _itensGrid[index] = el;
    }

    update();
  }

  void removeGrid(ExpedicaoCarrinhoPercursoConsultaModel item) {
    _itensGrid.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codCarrinho == item.codCarrinho &&
        el.item == item.item);

    update();
  }

  void removeAllGrid() {
    _itensGrid.clear();
    update();
  }

  void editGrid(
    SepararCarrinhoGridSource carrinhoGrid,
    ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta,
  ) {
    final dialog = SeparacaoPage(percursoEstagioConsulta);
    dialog.show();
  }

  void saveGrid(
    SepararCarrinhoGridSource carrinhoGrid,
    ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta,
  ) {
    print('SALVAR CARRINHO SEPARACAO');
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
}
