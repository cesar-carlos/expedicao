import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/app/app_color.dart';
import 'package:app_expedicao/src/app/app_data_grid.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_consulta_model.dart';
import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_unidade_medida_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class ConferirGridController extends GetxController {
  static const gridName = 'conferirGrid';
  static const footerId = 'conferirGridFooter';

  final iconSize = 19.0;
  bool _selectionMode = true;
  Color selectedRowColor = AppColor.gridRowSelectedRowColor;
  final Rx<String> _changeListListen = ''.obs;

  final List<ExpedicaoConferirItemConsultaModel> _itens = [];
  final List<ExpedicaoConferirItemConsultaModel> _itensSort = [];
  final List<ConferirSource> _sources = [];
  final List<ExpedicaoConferirItemUnidadeMedidaConsultaModel> _itemUnids = [];
  final dataGridController = DataGridController();
  final dataGridControllerConferencia = DataGridController();

  String? highlightedItem;

  Rx<String> get changeListListen => _changeListListen;

  bool get selectionMode => _selectionMode;

  List<DataGridRow> get selectedoRows => dataGridController.selectedRows;
  int get selectedIndex => dataGridController.selectedIndex;

  List<ExpedicaoConferirItemConsultaModel> get itens => _itens;
  List<ExpedicaoConferirItemConsultaModel> get itensSort => _itensSort;

  void attachSource(ConferirSource source) {
    if (_sources.contains(source)) {
      return;
    }
    _sources.add(source);
    source.setRows(_itensSort);
  }

  void detachSource(ConferirSource source) {
    _sources.remove(source);
  }


  @override
  void onClose() {
    dataGridController.dispose();
    dataGridControllerConferencia.dispose();
    _changeListListen.close();
    super.onClose();
  }

  void addGrid(ExpedicaoConferirItemConsultaModel item) {
    _itens.add(item);
    final index = _sortedInsertIndex(item.item);
    _itensSort.insert(index, item);
    for (final source in _sources) {
      source.insertRow(index, item);
    }
    _bumpListListen();
    update([footerId]);
  }

  void addAllGrid(List<ExpedicaoConferirItemConsultaModel> itens) {
    _itens.addAll(itens);
    _rebuildSort();
    _syncAll();
    _bumpListListen();
    update([footerId]);
  }

  void updateGrid(ExpedicaoConferirItemConsultaModel item) {
    final index = _itens.indexWhere((el) => el.item == item.item);
    if (index < 0) {
      return;
    }

    final previous = _itens[index];
    _itens[index] = item;
    final sortIndex = _itensSort.indexWhere((el) => el.item == item.item);
    if (sortIndex < 0) {
      return;
    }
    _itensSort[sortIndex] = item;
    _syncRow(sortIndex);

    final wasComplete = previous.quantidade == previous.quantidadeConferida;
    final nowComplete = item.quantidade == item.quantidadeConferida;
    if (wasComplete != nowComplete) {
      _bumpListListen();
    }
  }

  void updateAllGrid(List<ExpedicaoConferirItemConsultaModel> itens) {
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
    _bumpListListen();
  }

  void removeGrid(ExpedicaoConferirItemConsultaModel item) {
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
    if (highlightedItem == item.item) {
      highlightedItem = null;
    }
    _bumpListListen();
    update([footerId]);
  }

  void removeAllGrid() {
    _itens.clear();
    _itensSort.clear();
    highlightedItem = null;
    _syncAll();
    _bumpListListen();
    update([footerId]);
  }

  void addUnidade(ExpedicaoConferirItemUnidadeMedidaConsultaModel item) {
    _itemUnids.add(item);
  }

  void addAllUnidade(
      List<ExpedicaoConferirItemUnidadeMedidaConsultaModel> itens) {
    _itemUnids.addAll(itens);
  }

  void updateUnidade(ExpedicaoConferirItemUnidadeMedidaConsultaModel item) {
    final index = _itemUnids.indexWhere((el) => el.item == item.item);
    if (index < 0) {
      return;
    }
    _itemUnids[index] = item;
  }

  void updateAllUnidade(
      List<ExpedicaoConferirItemUnidadeMedidaConsultaModel> itens) {
    for (var el in itens) {
      final index = _itemUnids.indexWhere((i) => i.item == el.item);
      if (index < 0) {
        continue;
      }
      _itemUnids[index] = el;
    }
  }

  void removeUnidade(ExpedicaoConferirItemUnidadeMedidaConsultaModel item) {
    _itemUnids.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codConferir == item.codConferir &&
        el.item == item.item);
  }

  bool _applyingSelection = false;
  bool get applyingSelection => _applyingSelection;

  void setSelectedRow(
    int index, {
    bool scroll = true,
    bool scrollMain = true,
    bool scrollConferencia = true,
    bool canAnimate = true,
  }) {
    _applySelectedRow(
      dataGridController,
      index,
      scroll: scroll && scrollMain,
      canAnimate: canAnimate,
    );
    _applySelectedRow(
      dataGridControllerConferencia,
      index,
      scroll: scroll && scrollConferencia,
      canAnimate: canAnimate,
    );
  }

  /// Um único foco de row: scan posiciona e rola; clique do usuário só troca a row.
  /// [scrollMain] rola a grid da tela Conferir (atrás do modal).
  /// [scrollConferencia] rola a grid visível dentro do modal de conferência.
  void highlightItem(
    String item, {
    bool scroll = true,
    bool scrollMain = true,
    bool scrollConferencia = true,
  }) {
    if (highlightedItem == item && !scroll) {
      return;
    }

    _applyingSelection = true;
    highlightedItem = item;
    _refreshVisible();
    setSelectedRow(
      findIndexItem(item),
      scroll: scroll,
      scrollMain: scrollMain,
      scrollConferencia: scrollConferencia,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyingSelection = false;
    });
  }

  void ensureHighlightedVisible({
    bool scrollMain = false,
    bool scrollConferencia = true,
  }) {
    final item = highlightedItem;
    if (item == null) {
      return;
    }

    setSelectedRow(
      findIndexItem(item),
      scrollMain: scrollMain,
      scrollConferencia: scrollConferencia,
      canAnimate: false,
    );
  }

  void clearHighlight() {
    highlightedItem = null;
    dataGridController.clearSelection();
    dataGridControllerConferencia.clearSelection();
    _refreshVisible();
  }

  void _applySelectedRow(
    DataGridController target,
    int index, {
    bool scroll = true,
    bool canAnimate = true,
  }) {
    final rowCount = itensSort.length;
    if (index < 0 || index >= rowCount) {
      return;
    }

    target.selectAndScrollToRow(
      index,
      scroll: scroll,
      canAnimate: canAnimate,
      rowCount: rowCount,
    );
  }

  int _sortedInsertIndex(String item) {
    var index = 0;
    while (index < _itensSort.length &&
        _itensSort[index].item.compareTo(item) < 0) {
      index++;
    }
    return index;
  }

  void _rebuildSort() {
    _itensSort
      ..clear()
      ..addAll(_itens)
      ..sort((a, b) => a.item.compareTo(b.item));
  }

  void _syncAll() {
    for (final source in _sources) {
      source.setRows(_itensSort);
    }
  }

  void _syncRow(int index) {
    if (index < 0 || index >= _itensSort.length) {
      _syncAll();
      return;
    }

    final item = _itensSort[index];
    for (final source in _sources) {
      if (source.rows.length == _itensSort.length) {
        source.replaceRow(index, item);
      } else {
        source.setRows(_itensSort);
      }
    }
  }

  void _refreshVisible() {
    for (final source in _sources) {
      source.refresh();
    }
  }

  void _bumpListListen() {
    _changeListListen.value = DateTime.now().toString();
  }

  double totalQuantity() {
    return _itens.fold<double>(0.00, (acm, el) => acm + el.quantidade);
  }

  double totalQuantitySeparetion() {
    return _itens.fold<double>(0.00, (acm, el) => acm + el.quantidadeConferida);
  }

  double totalQtdProduct(int codProduto) {
    return _itens
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidade);
  }

  double totalQtdProductChecked(int codProduto) {
    return _itens
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidadeConferida);
  }

  bool isComplite() {
    return _itens.every((el) => el.quantidade == el.quantidadeConferida);
  }

  bool isCompliteCart(
    int codCarrinho,
  ) {
    return _itens
        .where((el) => el.codCarrinho == codCarrinho)
        .every((el) => el.quantidade == el.quantidadeConferida);
  }

  ExpedicaoConferirItemConsultaModel? findItem(String item) {
    final el = _itens.where((el) => el.item == item);
    if (el.isEmpty) {
      return null;
    }
    return el.first;
  }

  bool existsBarCode(String barCode) {
    final el = _itemUnids.where((el) => el.codigoBarras == barCode).toList();
    if (el.isEmpty) return false;
    return true;
  }

  bool existsCodProduto(int codProduto) {
    final el = _itens.where((el) => el.codProduto == codProduto).toList();
    if (el.isEmpty) return false;
    return true;
  }

  int? findcodProdutoFromBarCode(String barCode) {
    final el = _itemUnids.where((el) => el.codigoBarras == barCode);
    if (el.isEmpty) {
      return null;
    }
    return el.first.codProduto;
  }

  int findIndexCodProduto(int codProduto) {
    return itensSort.indexWhere((el) => el.codProduto == codProduto);
  }

  int findIndexItem(String item) {
    return itensSort.indexWhere((el) => el.item == item);
  }

  ExpedicaoConferirItemConsultaModel? findBarCode(String barCode) {
    final unidades =
        _itemUnids.where((el) => el.codigoBarras == barCode).toList();
    if (unidades.isEmpty) return null;

    final el = _itens.where((el) => el.item == unidades.first.item).toList();
    if (el.isEmpty) return null;
    return el.first;
  }

  ExpedicaoConferirItemConsultaModel? findCodProduto(int codProduto) {
    final el = _itens.where((el) => el.codProduto == codProduto).toList();
    if (el.isEmpty) return null;
    return el.first;
  }

  List<ExpedicaoConferirItemUnidadeMedidaConsultaModel>? findUnidadesProduto(
      int codProduto) {
    final el = _itemUnids.where((el) => el.codProduto == codProduto).toList();
    return el;
  }

  Future<void> recalc() async {
    final repository = SeparacaoItemRepository();
    List<ExpedicaoConferirItemConsultaModel> conferirItem = [];

    for (var el in _itens) {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', el.codEmpresa)
          .equals('CodConferirEstoque', el.codConferir)
          .equals('CodProduto', el.codProduto)
          .notEquals('Situacao', ExpedicaoSituacaoModel.cancelada);

      final separacaoItens = await repository.select(queryBuilder);

      if (separacaoItens.isEmpty) {
        conferirItem.add(el.copyWith(quantidadeConferida: 0.00));
        continue;
      }

      double totalSeparado = separacaoItens.fold<double>(
          0.00, (previousValue, element) => previousValue + element.quantidade);

      conferirItem.add(el.copyWith(quantidadeConferida: totalSeparado));
    }

    for (var el in conferirItem) {
      updateGrid(el);
    }
  }

  Color rowColor(
    DataGridRow dataGridRow,
    ExpedicaoConferirItemConsultaModel item,
  ) {
    if (item.quantidade == item.quantidadeConferida) {
      return AppColor.gridRowSelectedComplit;
    }

    return Colors.white;
  }

  void disableSelectionMode() {
    _selectionMode = false;
  }

  void enableSelectionMode() {
    _selectionMode = true;
  }

  Icon iconIndicator(ExpedicaoConferirItemConsultaModel item) {
    if (item.quantidade == item.quantidadeConferida) {
      return Icon(
        BootstrapIcons.check_circle_fill,
        color: Colors.green,
        size: iconSize,
      );
    }

    if (item.quantidade < item.quantidadeConferida) {
      return Icon(
        BootstrapIcons.exclamation_circle_fill,
        color: Colors.red,
        size: iconSize,
      );
    }

    return Icon(
      BootstrapIcons.box,
      color: Colors.blue,
      size: iconSize,
    );
  }
}
