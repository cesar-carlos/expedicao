import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separacao/separacao_carrinho_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SeparacaoCarrinhoGridController extends GetxController {
  static const gridName = 'separacaoCarrinhoGrid';

  final DataGridController dataGridController = DataGridController();
  late List<ExpedicaSeparacaoItemConsultaModel> _itensGrid = [];

  List<ExpedicaSeparacaoItemConsultaModel> get itens => _itensGrid;
  List<ExpedicaSeparacaoItemConsultaModel> get itensSort =>
      _itensGrid.toList()..sort((a, b) => b.item.compareTo(a.item));

  List<DataGridRow> get selectedoRows => dataGridController.selectedRows;

  //eventos
  void Function(ExpedicaSeparacaoItemConsultaModel item)? onPressedEditItem;
  void Function(ExpedicaSeparacaoItemConsultaModel item)? onPressedRemoveItem;

  void addGrid(ExpedicaSeparacaoItemConsultaModel item) {
    _itensGrid.add(item);
  }

  void addAllGrid(List<ExpedicaSeparacaoItemConsultaModel> itens) {
    _itensGrid.addAll(itens);
  }

  void updateGrid(ExpedicaSeparacaoItemConsultaModel item) {
    final index = _itensGrid.indexWhere((el) => el.item == item.item);
    _itensGrid[index] = item;
  }

  void updateAllGrid(List<ExpedicaSeparacaoItemConsultaModel> itens) {
    for (var el in itens) {
      final index = _itensGrid.indexWhere((i) => i.item == el.item);
      _itensGrid[index] = el;
    }
  }

  void removeGrid(ExpedicaSeparacaoItemConsultaModel item) {
    _itensGrid.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codSepararEstoque == item.codSepararEstoque &&
        el.item == item.item);
  }

  void removeAllGrid() {
    _itensGrid.clear();
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

  double totalQuantity() {
    return _itensGrid.fold<double>(0.00, (acm, el) => acm + el.quantidade);
  }

  double totalQtdProduct(int codProduto) {
    return _itensGrid
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidade);
  }

  Future<void> onEditItem(
    SeparacaoCarrinhoGridSource grid,
    ExpedicaSeparacaoItemConsultaModel item,
  ) async {
    onPressedEditItem?.call(item);
  }

  Future<void> onRemoveItem(
    SeparacaoCarrinhoGridSource grid,
    ExpedicaSeparacaoItemConsultaModel item,
  ) async {
    final bool? confirmation = await ConfirmationDialogWidget.show(
      context: Get.context!,
      message: 'Deseja realmente cancelar?',
      detail: 'Ao cancelar, os itens serão removido do carrinho!',
    );

    if (confirmation != null && confirmation) {
      onPressedRemoveItem?.call(item);
    }
  }
}
