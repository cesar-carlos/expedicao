import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_consulta_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ConferenciaCarrinhoGridController extends GetxController {
  static const gridName = 'conferenciaCarrinhoGrid';
  final DataGridController dataGridController = DataGridController();
  late List<ExpedicaConferenciaItemConsultaModel> _itensGrid;

  List<ExpedicaConferenciaItemConsultaModel> get itens => _itensGrid;
  List<ExpedicaConferenciaItemConsultaModel> get itensSort =>
      _itensGrid.toList()..sort((a, b) => b.item.compareTo(a.item));

  List<DataGridRow> get selectedoRows => dataGridController.selectedRows;

  //eventos
  void Function(ExpedicaConferenciaItemConsultaModel item)? onPressedEditItem;
  void Function(ExpedicaConferenciaItemConsultaModel item)? onPressedRemoveItem;

  @override
  void onInit() {
    super.onInit();

    _itensGrid = [];
  }

  void addGrid(ExpedicaConferenciaItemConsultaModel item) {
    _itensGrid.add(item);
  }

  void addAllGrid(List<ExpedicaConferenciaItemConsultaModel> itens) {
    _itensGrid.addAll(itens);
  }

  void updateGrid(ExpedicaConferenciaItemConsultaModel item) {
    final index = _itensGrid.indexWhere((el) => el.item == item.item);
    _itensGrid[index] = item;
  }

  void updateAllGrid(List<ExpedicaConferenciaItemConsultaModel> itens) {
    for (var el in itens) {
      final index = _itensGrid.indexWhere((i) => i.item == el.item);
      _itensGrid[index] = el;
    }
  }

  void removeGrid(ExpedicaConferenciaItemConsultaModel item) {
    _itensGrid.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codConferir == item.codConferir &&
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
