import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';

class SeparacaoCarrinhoGridController extends GetxController {
  final RxList<ExpedicaSeparacaoItemConsultaModel> _itens = RxList.empty();
  List<ExpedicaSeparacaoItemConsultaModel> get itens => _itens;
  List<ExpedicaSeparacaoItemConsultaModel> get itensSort =>
      _itens.toList()..sort((a, b) => b.item.compareTo(a.item));

  void addItem(ExpedicaSeparacaoItemConsultaModel item) {
    _itens.add(item);
  }

  void removeItem(ExpedicaSeparacaoItemConsultaModel item) {
    _itens.remove(item);
  }

  void clear() {
    _itens.clear();
  }

  @override
  void onClose() {
    _itens.close();
    super.onClose();
  }
}
