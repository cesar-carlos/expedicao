import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/app/app_data_grid.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separacao/separacao_carrinho_grid_source.dart';

class SeparacaoCarrinhoGridController extends GetxController {
  static const gridName = 'separacaoCarrinhoGrid';

  final List<ExpedicaSeparacaoItemConsultaModel> _itens = [];
  final dataGridController = DataGridController();

  List<ExpedicaSeparacaoItemConsultaModel> get itens => _itens;
  List<ExpedicaSeparacaoItemConsultaModel> get itensSort =>
      _itens.toList()..sort((a, b) => b.item.compareTo(a.item));

  List<DataGridRow> get selectedoRows => dataGridController.selectedRows;

  void Function(ExpedicaSeparacaoItemConsultaModel item)? onPressedEditItem;
  void Function(ExpedicaSeparacaoItemConsultaModel item)? onPressedRemoveItem;

  void addGrid(ExpedicaSeparacaoItemConsultaModel item) {
    if (_itens.any((el) => el.item == item.item)) {
      return;
    }
    _itens.add(item);
  }

  void addAllGrid(List<ExpedicaSeparacaoItemConsultaModel> itens) {
    _itens.addAll(itens);
  }

  void updateGrid(ExpedicaSeparacaoItemConsultaModel item) {
    final index = _itens.indexWhere((el) => el.item == item.item);
    _itens[index] = item;
  }

  void updateAllGrid(List<ExpedicaSeparacaoItemConsultaModel> itens) {
    for (var el in itens) {
      final index = _itens.indexWhere((i) => i.item == el.item);
      _itens[index] = el;
    }
  }

  void removeGrid(ExpedicaSeparacaoItemConsultaModel item) {
    _itens.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codSepararEstoque == item.codSepararEstoque &&
        el.item == item.item);
  }

  void removeAllGrid() {
    _itens.clear();
  }

  int findIndexItem(String item) {
    return itensSort.indexWhere((el) => el.item == item);
  }

  void setSelectedRow(int index) {
    dataGridController.selectAndScrollToRow(index);
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
    SeparacaoCarrinhoGridSource grid,
    ExpedicaSeparacaoItemConsultaModel item,
  ) async {
    onPressedEditItem?.call(item);
  }

  Future<void> onRemoveItem(
    SeparacaoCarrinhoGridSource grid,
    ExpedicaSeparacaoItemConsultaModel item,
  ) async {
    onPressedRemoveItem?.call(item);
  }
}
