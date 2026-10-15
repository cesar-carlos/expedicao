import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/app/app_data_grid.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_consulta_model.dart';

class ConferenciaCarrinhoGridController extends GetxController {
  static const gridName = 'conferenciaCarrinhoGrid';
  static const footerId = 'conferenciaCarrinhoGridFooter';

  final dataGridController = DataGridController();
  final List<ExpedicaConferenciaItemConsultaModel> _itens = [];
  final List<ExpedicaConferenciaItemConsultaModel> _itensSort = [];
  final List<ConferenciaCarrinhoGridSource> _sources = [];

  String? highlightedItem;

  List<ExpedicaConferenciaItemConsultaModel> get itens => _itens;
  List<ExpedicaConferenciaItemConsultaModel> get itensSort => _itensSort;

  void attachSource(ConferenciaCarrinhoGridSource source) {
    if (_sources.contains(source)) {
      return;
    }
    _sources.add(source);
    source.setRows(_itensSort);
  }

  void detachSource(ConferenciaCarrinhoGridSource source) {
    _sources.remove(source);
  }

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
    final index = _sortedInsertIndex(item.item);
    _itensSort.insert(index, item);
    for (final source in _sources) {
      source.insertRow(index, item);
    }
    update([footerId]);
  }

  void addAllGrid(List<ExpedicaConferenciaItemConsultaModel> itens) {
    _itens.addAll(itens);
    _rebuildSort();
    _syncAll();
    update([footerId]);
  }

  void updateGrid(ExpedicaConferenciaItemConsultaModel item) {
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

  void updateAllGrid(List<ExpedicaConferenciaItemConsultaModel> itens) {
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

  void removeGrid(ExpedicaConferenciaItemConsultaModel item) {
    if (highlightedItem == item.item) {
      highlightedItem = null;
    }
    dataGridController.clearSelection();
    final sortIndex = _itensSort.indexWhere((el) => el.item == item.item);
    _itens.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codConferir == item.codConferir &&
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
    highlightedItem = null;
    dataGridController.clearSelection();
    _itens.clear();
    _itensSort.clear();
    _syncAll();
    update([footerId]);
  }

  int findIndexItem(String item) {
    return _itensSort.indexWhere((el) => el.item == item);
  }

  void highlightItem(String item, {bool scroll = true, bool canAnimate = true}) {
    highlightedItem = item;
    _refreshVisible();
    setSelectedRow(
      findIndexItem(item),
      scroll: scroll,
      canAnimate: canAnimate,
    );
  }

  void ensureHighlightedVisible() {
    final item = highlightedItem;
    if (item == null) {
      return;
    }

    setSelectedRow(findIndexItem(item), canAnimate: false);
  }

  void clearHighlight() {
    highlightedItem = null;
    dataGridController.clearSelection();
    _refreshVisible();
  }

  void setSelectedRow(
    int index, {
    bool scroll = true,
    bool canAnimate = true,
  }) {
    dataGridController.selectAndScrollToRow(
      index,
      scroll: scroll,
      canAnimate: canAnimate,
      rowCount: _itensSort.length,
    );
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

  void _refreshVisible() {
    for (final source in _sources) {
      source.refresh();
    }
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
