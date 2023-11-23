import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_source.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';

class SeparacaoCarrinhoGridController extends GetxController {
  final RxList<ExpedicaSeparacaoItemConsultaModel> _itens = RxList.empty();

  List<ExpedicaSeparacaoItemConsultaModel> get itens => _itens;
  List<ExpedicaSeparacaoItemConsultaModel> get itensSort =>
      _itens.toList()..sort((a, b) => b.item.compareTo(a.item));

  void Function(ExpedicaSeparacaoItemConsultaModel item)? onPressedRemoveItem;

  void addItem(ExpedicaSeparacaoItemConsultaModel item) => _itens.add(item);

  void removeItem(ExpedicaSeparacaoItemConsultaModel item) =>
      _itens.remove(item);

  void clear() => _itens.clear();

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
