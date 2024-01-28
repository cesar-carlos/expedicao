import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/widget/complit_animation_icon_widget.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_unidade_medida_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/pages/common/widget/alert_animation_icon_widget.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';

class SepararGridController extends GetxController {
  static const gridName = 'separarGrid';

  final List<ExpedicaoSepararItemConsultaModel> _itens = [];
  final List<ExpedicaoSepararItemUnidadeMedidaConsultaModel> _itemUnids = [];
  final DataGridController dataGridController = DataGridController();
  final _processoExecutavel = Get.find<ProcessoExecutavelModel>();

  List<DataGridRow> get selectedoRows => dataGridController.selectedRows;
  List<ExpedicaoSepararItemConsultaModel> get itens => _itens;
  List<ExpedicaoSepararItemConsultaModel> get itensSort =>
      _itens.toList()..sort((a, b) => a.item.compareTo(b.item));

  @override
  void onInit() {
    super.onInit();
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

  //ITENS
  void addGrid(ExpedicaoSepararItemConsultaModel item) {
    _itens.add(item);
  }

  void addAllGrid(List<ExpedicaoSepararItemConsultaModel> itens) {
    _itens.addAll(itens);
  }

  void updateGrid(ExpedicaoSepararItemConsultaModel item) {
    final index = _itens.indexWhere((el) => el.item == item.item);
    _itens[index] = item;
  }

  void updateAllGrid(List<ExpedicaoSepararItemConsultaModel> itens) {
    for (var el in itens) {
      final index = _itens.indexWhere((i) => i.item == el.item);
      _itens[index] = el;
    }
  }

  void removeGrid(ExpedicaoSepararItemConsultaModel item) {
    _itens.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codSepararEstoque == item.codSepararEstoque &&
        el.item == item.item);
  }

  void removeAllGrid() {
    _itens.clear();
  }

  //UNIDADES
  void addUnidade(ExpedicaoSepararItemUnidadeMedidaConsultaModel item) {
    _itemUnids.add(item);
  }

  void addAllUnidade(
      List<ExpedicaoSepararItemUnidadeMedidaConsultaModel> itens) {
    _itemUnids.addAll(itens);
  }

  void updateUnidade(ExpedicaoSepararItemUnidadeMedidaConsultaModel item) {
    final index = _itemUnids.indexWhere((el) => el.item == item.item);
    _itemUnids[index] = item;
  }

  void updateAllUnidade(
      List<ExpedicaoSepararItemUnidadeMedidaConsultaModel> itens) {
    for (var el in itens) {
      final index = _itemUnids.indexWhere((i) => i.item == el.item);
      _itemUnids[index] = el;
    }
  }

  void removeUnidade(ExpedicaoSepararItemUnidadeMedidaConsultaModel item) {
    _itemUnids.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codSepararEstoque == item.codSepararEstoque &&
        el.item == item.item);
  }

  //
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

  double totalQuantitySeparetion() {
    return _itens.fold<double>(0.00, (acm, el) => acm + el.quantidadeSeparacao);
  }

  double totalQtdProduct(int codProduto) {
    return _itens
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidade);
  }

  double totalQtdProductInternal(int codProduto) {
    return _itens
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidadeInterna);
  }

  double totalQtdProductExternal(int codProduto) {
    return _itens
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidadeExterna);
  }

  double totalQtdProductSeparation(int codProduto) {
    return _itens
        .where((el) => el.codProduto == codProduto)
        .fold<double>(0.00, (acm, el) => acm + el.quantidadeSeparacao);
  }

  //LOCALIZACAO
  ExpedicaoSepararItemConsultaModel findItem(String Item) {
    final el = _itens.where((el) => el.item == Item).toList();
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

  int? findCodProdutoFromBarCode(String barCode) {
    final el = _itemUnids.where((el) => el.codigoBarras == barCode).toList();
    return el.first.codProduto;
  }

  int findIndexCodProduto(int codProduto) {
    final el = _itens.where((el) => el.codProduto == codProduto).toList();
    return _itens.indexOf(el.first);
  }

  int findIndexItem(String item) {
    final el = _itens.where((el) => el.item == item).toList();
    return _itens.indexOf(el.first);
  }

  ExpedicaoSepararItemConsultaModel? findBarCode(String barCode) {
    final unidades =
        _itemUnids.where((el) => el.codigoBarras == barCode).toList();
    if (unidades.isEmpty) return null;

    final el = _itens.where((el) => el.item == unidades.first.item).toList();
    return el.first;
  }

  ExpedicaoSepararItemConsultaModel? findCodProduto(int codProduto) {
    final el = _itens.where((el) => el.codProduto == codProduto).toList();
    return el.first;
  }

  List<ExpedicaoSepararItemUnidadeMedidaConsultaModel>? findUnidadesProduto(
      int codProduto) {
    final el = _itemUnids.where((el) => el.codProduto == codProduto).toList();
    return el;
  }

  //
  Future<void> recalc() async {
    final repository = SeparacaoItemRepository();
    List<ExpedicaoSepararItemConsultaModel> separarItem = [];

    for (var el in _itens) {
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

  Color rowColor(ExpedicaoSepararItemConsultaModel el) {
    if (el.quantidade == el.quantidadeSeparacao) {
      return Color(0xFFffff00);
    }

    return Colors.white;
  }

  iconIndicator(ExpedicaoSepararItemConsultaModel item) {
    if (item.quantidade == item.quantidadeSeparacao) {
      return const ComplitAnimationIconWidget();
    }

    if (item.quantidade < item.quantidadeSeparacao) {
      return const AlertAnimationIconWidget();
    }

    if (_processoExecutavel.codSetorEstoque != null) {
      if (item.codSetorEstoque != _processoExecutavel.codSetorEstoque) {
        return const Icon(
          BootstrapIcons.ban,
          color: Colors.red,
          size: 17,
        );
      }
    }

    return Icon(
      BootstrapIcons.box,
      color: Theme.of(Get.context!).primaryColor,
      size: 17,
    );
  }
}
