import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SeparacaoCarrinhoGridController extends GetxController {
  final RxList<ExpedicaSeparacaoItemConsultaModel> _itens = RxList.empty();
  final dataGridController = DataGridController();

  List<ExpedicaSeparacaoItemConsultaModel> get itens => _itens;
  List<ExpedicaSeparacaoItemConsultaModel> get itensSort =>
      _itens.toList()..sort((a, b) => b.item.compareTo(a.item));

  //eventos
  void Function(ExpedicaSeparacaoItemConsultaModel item)? onPressedEditItem;
  void Function(ExpedicaSeparacaoItemConsultaModel item)? onPressedRemoveItem;

  void add(ExpedicaSeparacaoItemConsultaModel item) => _itens.add(item);

  void addAll(List<ExpedicaSeparacaoItemConsultaModel> itens) =>
      _itens.addAll(itens);

  void remove(ExpedicaSeparacaoItemConsultaModel item) {
    _itens.removeWhere((el) =>
        el.codEmpresa == item.codEmpresa &&
        el.codSepararEstoque == item.codSepararEstoque &&
        el.item == item.item);
  }

  void removeAll() {
    _itens.clear();
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
    final bool? confirmation = await ConfirmationDialogWidget.show(
      context: Get.context!,
      message: 'Deseja realmente cancelar?',
      detail: 'Ao cancelar, os itens serão removido do carrinho!',
    );

    if (confirmation != null && confirmation) {
      onPressedRemoveItem?.call(item);
    }
  }

  @override
  void onClose() {
    _itens.close();
    super.onClose();
  }
}
