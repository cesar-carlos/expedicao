import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';

class SeparacaoCarrinhoGridController extends GetxController {
  final RxList<ExpedicaSeparacaoItemConsultaModel> _itens = RxList.empty();
  List<ExpedicaSeparacaoItemConsultaModel> get itens => _itens;

  void addItem(ExpedicaSeparacaoItemConsultaModel item) {
    _itens.add(item);
  }

  void removeItem(ExpedicaSeparacaoItemConsultaModel item) {
    _itens.remove(item);
  }

  List<ExpedicaSeparacaoItemConsultaModel> itensCarrinho(
      {required int codCarrinho}) {
    return _itens.where((el) => el.codCarrinho == codCarrinho).toList();
  }
}
