import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_consulta_model.dart';

class ConferenciaCarrinhoGridController extends GetxController {
  static const gridName = 'conferenciaCarrinhoGrid';

  final DataGridController dataGridController = DataGridController();
  late List<ExpedicaConferenciaItemConsultaModel> _itens = [];

  List<ExpedicaConferenciaItemConsultaModel> get itens => _itens;
  List<ExpedicaConferenciaItemConsultaModel> get itensSort =>
      _itens.toList()..sort((a, b) => b.item.compareTo(a.item));

  List<DataGridRow> get selectedoRows => dataGridController.selectedRows;

  //eventos
  void Function(ExpedicaConferenciaItemConsultaModel item)? onPressedEditItem;
  void Function(ExpedicaConferenciaItemConsultaModel item)? onPressedRemoveItem;

  @override
  void onInit() {
    super.onInit();
  }

  void addGrid(ExpedicaConferenciaItemConsultaModel item) {
    _itens.add(item);
  }

  void addAllGrid(List<ExpedicaConferenciaItemConsultaModel> itens) {
    _itens.addAll(itens);
  }

  void updateGrid(ExpedicaConferenciaItemConsultaModel item) {
    final index = _itens.indexWhere((el) => el.item == item.item);
    _itens[index] = item;
  }

  void updateAllGrid(List<ExpedicaConferenciaItemConsultaModel> itens) {
    for (var el in itens) {
      final index = _itens.indexWhere((i) => i.item == el.item);
      _itens[index] = el;
    }
  }

  void removeGrid(ExpedicaConferenciaItemConsultaModel item) {
    _itens.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codConferir == item.codConferir &&
        el.item == item.item);
  }

  void removeAllGrid() {
    _itens.clear();
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
