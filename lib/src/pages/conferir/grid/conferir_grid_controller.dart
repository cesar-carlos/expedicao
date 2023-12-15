import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/widget/complit_animation_icon_widget.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/pages/common/widget/alert_animation_icon_widget.dart';
import 'package:app_expedicao/src/pages/common/widget/box_animation_icon_widget.dart';

class ConferirGridController extends GetxController {
  static const gridName = 'conferirGrid';
  final DataGridController dataGridController = DataGridController();
  late List<ExpedicaoConferirItemConsultaModel> _itensGrid;

  List<DataGridRow> get selectedoRows => dataGridController.selectedRows;
  List<ExpedicaoConferirItemConsultaModel> get itens => _itensGrid;
  List<ExpedicaoConferirItemConsultaModel> get itensSort =>
      _itensGrid.toList()..sort((a, b) => a.item.compareTo(b.item));

  @override
  void onInit() {
    super.onInit();

    _itensGrid = [];
  }

  void addGrid(ExpedicaoConferirItemConsultaModel item) {
    _itensGrid.add(item);
  }

  void addAllGrid(List<ExpedicaoConferirItemConsultaModel> itens) {
    _itensGrid.addAll(itens);
  }

  void updateGrid(ExpedicaoConferirItemConsultaModel item) {
    final index = _itensGrid.indexWhere((el) => el.item == item.item);
    _itensGrid[index] = item;
  }

  void updateAllGrid(List<ExpedicaoConferirItemConsultaModel> itens) {
    for (var el in itens) {
      final index = _itensGrid.indexWhere((i) => i.item == el.item);
      _itensGrid[index] = el;
    }
  }

  void removeGrid(ExpedicaoConferirItemConsultaModel item) {
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

  double totalQuantitySeparetion() {
    return _itensGrid.fold<double>(
        0.00, (acm, el) => acm + el.quantidadeConferida);
  }

  double totalQtdProduct(int codProduto) {
    return _itensGrid
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidade);
  }

  double totalQtdProductChecked(int codProduto) {
    return _itensGrid
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidadeConferida);
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

  ExpedicaoConferirItemConsultaModel? findBarCode(String barCode) {
    final el = _itensGrid.where((el) => el.codigoBarras == barCode).toList();
    return el.first;
  }

  ExpedicaoConferirItemConsultaModel? findCodProduto(int codProduto) {
    final el = _itensGrid.where((el) => el.codProduto == codProduto).toList();
    return el.first;
  }

  Future<void> recalc() async {
    final repository = SeparacaoItemRepository();
    List<ExpedicaoConferirItemConsultaModel> conferirItem = [];

    for (var el in _itensGrid) {
      final separacaoItens = await repository.select('''
          CodEmpresa = ${el.codEmpresa}
        AND CodConferirEstoque = ${el.codConferir}
        AND CodProduto = ${el.codProduto}
        AND Situacao <> ${ExpedicaoSituacaoModel.cancelada}
      ''');

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

  iconIndicator(ExpedicaoConferirItemConsultaModel item) {
    if (item.quantidade == item.quantidadeConferida) {
      return const ComplitAnimationIconWidget();
    }

    if (item.quantidade < item.quantidadeConferida) {
      return const AlertAnimationIconWidget();
    }

    return const BoxAnimationIconWidget();
  }
}
