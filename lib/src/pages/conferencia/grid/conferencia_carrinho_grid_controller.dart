import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/app/app_data_grid.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_consulta_model.dart';

class ConferenciaCarrinhoGridController extends GetxController {
  static const gridName = 'conferenciaCarrinhoGrid';

  final dataGridController = DataGridController();
  late final List<ExpedicaConferenciaItemConsultaModel> _itens = [];

  List<ExpedicaConferenciaItemConsultaModel> get itens => _itens;
  List<ExpedicaConferenciaItemConsultaModel> get itensSort =>
      _itens.toList()..sort((a, b) => b.item.compareTo(a.item));

  List<DataGridRow> get selectedoRows => dataGridController.selectedRows;

  //eventos
  void Function(ExpedicaConferenciaItemConsultaModel item)? onPressedEditItem;
  void Function(ExpedicaConferenciaItemConsultaModel item)? onPressedRemoveItem;


  @override
  void onClose() {
    super.onClose();
    dataGridController.dispose();
  }

  void addGrid(ExpedicaConferenciaItemConsultaModel item) {
    _itens.add(item);
  }

  void addAllGrid(List<ExpedicaConferenciaItemConsultaModel> itens) {
    _itens.addAll(itens);
  }

  void updateGrid(ExpedicaConferenciaItemConsultaModel item) {
    final index = _itens.indexWhere((el) => el.item == item.item);
    if (index < 0) {
      return;
    }
    _itens[index] = item;
  }

  void updateAllGrid(List<ExpedicaConferenciaItemConsultaModel> itens) {
    for (var el in itens) {
      final index = _itens.indexWhere((i) => i.item == el.item);
      if (index < 0) {
        continue;
      }
      _itens[index] = el;
    }
  }

  void removeGrid(ExpedicaConferenciaItemConsultaModel item) {
    dataGridController.clearSelection();
    _itens.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codConferir == item.codConferir &&
        el.item == item.item);
  }

  void removeAllGrid() {
    dataGridController.clearSelection();
    _itens.clear();
  }

  void setSelectedRow(int index, {bool scroll = true}) {
    dataGridController.selectAndScrollToRow(
      index,
      scroll: scroll,
      rowCount: itensSort.length,
    );
  }

  double totalQuantity() {
    return _itens.fold<double>(0.00, (acm, el) => acm + el.quantidade);
  }

  double totalQtdProduct(int codProduto) {
    return _itens
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidade);
  }

  Future<void> onEditItem(
    ConferenciaCarrinhoGridSource grid,
    ExpedicaConferenciaItemConsultaModel item,
  ) async {
    onPressedEditItem?.call(item);
  }

  Future<void> onRemoveItem(
    ConferenciaCarrinhoGridSource grid,
    ExpedicaConferenciaItemConsultaModel item,
  ) async {
    onPressedRemoveItem?.call(item);
  }
}
