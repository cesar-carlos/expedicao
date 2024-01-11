import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/widget/complit_animation_icon_widget.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/pages/common/widget/alert_animation_icon_widget.dart';
import 'package:app_expedicao/src/pages/common/widget/box_animation_icon_widget.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SepararSetorGridController extends GetxController {
  static const gridName = 'separarSetorGrid';
  final DataGridController dataGridController = DataGridController();
  late List<ExpedicaoSepararItemConsultaModel> _itensGrid;
  final _processoExecutavel = Get.find<ProcessoExecutavelModel>();

  List<DataGridRow> get selectedoRows => dataGridController.selectedRows;
  List<ExpedicaoSepararItemConsultaModel> get itens => _itensGrid;
  List<ExpedicaoSepararItemConsultaModel> get itensSort =>
      _itensGrid.toList()..sort((a, b) => a.item.compareTo(b.item));

  @override
  void onInit() {
    super.onInit();
    _itensGrid = [];
  }

  getItensSort(int? codSetorEstoque) {
    if (codSetorEstoque == null) return itensSort;

    return itensSort.where((el) {
      if (el.codSetorEstoque == 0) return true;
      if (el.codSetorEstoque == codSetorEstoque) return true;

      return false;
    }).toList();
  }

  get itensSortSetor {
    return getItensSort(_processoExecutavel.codSetorEstoque);
  }

  void addGrid(ExpedicaoSepararItemConsultaModel item) {
    _itensGrid.add(item);
  }

  void addAllGrid(List<ExpedicaoSepararItemConsultaModel> itens) {
    _itensGrid.addAll(itens);
  }

  void updateGrid(ExpedicaoSepararItemConsultaModel item) {
    final index = _itensGrid.indexWhere((el) => el.item == item.item);
    _itensGrid[index] = item;
  }

  void updateAllGrid(List<ExpedicaoSepararItemConsultaModel> itens) {
    for (var el in itens) {
      final index = _itensGrid.indexWhere((i) => i.item == el.item);
      _itensGrid[index] = el;
    }
  }

  void removeGrid(ExpedicaoSepararItemConsultaModel item) {
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

  double totalQuantitySeparetion() {
    return _itensGrid.fold<double>(
        0.00, (acm, el) => acm + el.quantidadeSeparacao);
  }

  double totalQtdProduct(int codProduto) {
    return _itensGrid
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidade);
  }

  double totalQtdProductInternal(int codProduto) {
    return _itensGrid
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidadeInterna);
  }

  double totalQtdProductExternal(int codProduto) {
    return _itensGrid
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidadeExterna);
  }

  double totalQtdProductSeparation(int codProduto) {
    return _itensGrid
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidadeSeparacao);
  }

  bool existsBarCode(String barCode) {
    final el = _itensGrid.where((el) => el.codigoBarras == barCode).toList();
    if (el.isEmpty) return false;
    return true;
  }

  bool existsCodProduto(int codProduto) {
    final el = _itensGrid.where((el) => el.codProduto == codProduto).toList();
    if (el.isEmpty) return false;
    return true;
  }

  int? findcodProdutoFromBarCode(String barCode) {
    final el = _itensGrid.where((el) => el.codigoBarras == barCode).toList();
    return el.first.codProduto;
  }

  int findIndexCodProduto(int codProduto) {
    final el = _itensGrid.where((el) => el.codProduto == codProduto).toList();
    return _itensGrid.indexOf(el.first);
  }

  ExpedicaoSepararItemConsultaModel? findBarCode(String barCode) {
    final el = _itensGrid.where((el) => el.codigoBarras == barCode).toList();
    return el.first;
  }

  ExpedicaoSepararItemConsultaModel? findCodProduto(int codProduto) {
    final el = _itensGrid.where((el) => el.codProduto == codProduto).toList();
    return el.first;
  }

  Future<void> recalc() async {
    final repository = SeparacaoItemRepository();
    List<ExpedicaoSepararItemConsultaModel> separarItem = [];

    for (var el in _itensGrid) {
      final separacaoItens = await repository.select('''
            CodEmpresa = ${el.codEmpresa}
        AND CodSepararEstoque = ${el.codSepararEstoque}
        AND CodProduto = ${el.codProduto}
        AND Situacao <> ${ExpedicaoSituacaoModel.cancelada}
      ''');

      if (separacaoItens.isEmpty) {
        separarItem.add(el.copyWith(quantidadeSeparacao: 0.00));
        continue;
      }

      double totalSeparado = separacaoItens.fold<double>(
          0.00, (previousValue, element) => previousValue + element.quantidade);

      separarItem.add(el.copyWith(quantidadeSeparacao: totalSeparado));
    }

    for (var el in separarItem) {
      updateGrid(el);
    }
  }

  iconIndicator(ExpedicaoSepararItemConsultaModel item) {
    if (item.quantidade == item.quantidadeSeparacao) {
      return const ComplitAnimationIconWidget();
    }

    if (item.quantidade < item.quantidadeSeparacao) {
      return const AlertAnimationIconWidget();
    }

    return const BoxAnimationIconWidget();
  }
}
