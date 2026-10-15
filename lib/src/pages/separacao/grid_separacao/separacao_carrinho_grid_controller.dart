import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/app/app_data_grid.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separacao/separacao_carrinho_grid_source.dart';

class SeparacaoCarrinhoGridController extends GetxController {
  static const gridName = 'separacaoCarrinhoGrid';
  static const footerId = 'separacaoCarrinhoGridFooter';

  final List<ExpedicaSeparacaoItemConsultaModel> _itens = [];
  final List<ExpedicaSeparacaoItemConsultaModel> _itensSort = [];
  final List<SeparacaoCarrinhoGridSource> _sources = [];
  final dataGridController = DataGridController();

  List<ExpedicaSeparacaoItemConsultaModel> get itens => _itens;
  List<ExpedicaSeparacaoItemConsultaModel> get itensSort => _itensSort;

  void attachSource(SeparacaoCarrinhoGridSource source) {
    if (_sources.contains(source)) {
      return;
    }
    _sources.add(source);
    source.setRows(_itensSort);
  }

  void detachSource(SeparacaoCarrinhoGridSource source) {
    _sources.remove(source);
  }

  List<DataGridRow> get selectedoRows => dataGridController.selectedRows;

  void Function(ExpedicaSeparacaoItemConsultaModel item)? onPressedEditItem;
  void Function(ExpedicaSeparacaoItemConsultaModel item)? onPressedRemoveItem;

  void addGrid(ExpedicaSeparacaoItemConsultaModel item) {
    if (_itens.any((el) => el.item == item.item)) {
      return;
    }
    _itens.add(item);
    final index = _sortedInsertIndex(item.item);
    _itensSort.insert(index, item);
    for (final source in _sources) {
      source.insertRow(index, item);
    }
    update([footerId]);
  }

  void addAllGrid(List<ExpedicaSeparacaoItemConsultaModel> itens) {
    _itens.addAll(itens);
    _rebuildSort();
    _syncAll();
    update([footerId]);
  }

  void updateGrid(ExpedicaSeparacaoItemConsultaModel item) {
    final index = _itens.indexWhere((el) => el.item == item.item);
    if (index < 0) {
      return;
    }
    _itens[index] = item;
    final sortIndex = _itensSort.indexWhere((el) => el.item == item.item);
    if (sortIndex < 0) {
      return;
    }
    _itensSort[sortIndex] = item;
    for (final source in _sources) {
      if (source.rows.length == _itensSort.length) {
        source.replaceRow(sortIndex, item);
      } else {
        source.setRows(_itensSort);
      }
    }
  }

  void updateAllGrid(List<ExpedicaSeparacaoItemConsultaModel> itens) {
    for (var el in itens) {
      final index = _itens.indexWhere((i) => i.item == el.item);
      if (index < 0) {
        continue;
      }
      _itens[index] = el;
      final sortIndex = _itensSort.indexWhere((i) => i.item == el.item);
      if (sortIndex >= 0) {
        _itensSort[sortIndex] = el;
      }
    }
    _syncAll();
  }

  void removeGrid(ExpedicaSeparacaoItemConsultaModel item) {
    dataGridController.clearSelection();
    final sortIndex = _itensSort.indexWhere((el) => el.item == item.item);
    _itens.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codSepararEstoque == item.codSepararEstoque &&
        el.item == item.item);
    if (sortIndex >= 0) {
      _itensSort.removeAt(sortIndex);
      for (final source in _sources) {
        source.removeRowAt(sortIndex);
      }
    }
    update([footerId]);
  }

  void removeAllGrid() {
    dataGridController.clearSelection();
    _itens.clear();
    _itensSort.clear();
    _syncAll();
    update([footerId]);
  }

  int findIndexItem(String item) {
    return _itensSort.indexWhere((el) => el.item == item);
  }

  int _sortedInsertIndex(String item) {
    var index = 0;
    while (index < _itensSort.length &&
        _itensSort[index].item.compareTo(item) >= 0) {
      index++;
    }
    return index;
  }

  void _rebuildSort() {
    _itensSort
      ..clear()
      ..addAll(_itens)
      ..sort((a, b) => b.item.compareTo(a.item));
  }

  void _syncAll() {
    for (final source in _sources) {
      source.setRows(_itensSort);
    }
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
