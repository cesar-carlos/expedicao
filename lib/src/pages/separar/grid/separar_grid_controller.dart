import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';

class SepararGridController extends GetxController {
  final RxList<ExpedicaoSepararItemConsultaModel> _itens = RxList.empty();

  List<ExpedicaoSepararItemConsultaModel> get itens => _itens;

  addItem(ExpedicaoSepararItemConsultaModel item) {
    _itens.add(item);
  }

  removeItem(ExpedicaoSepararItemConsultaModel item) {
    _itens.remove(item);
  }

  removeAll() {
    _itens.clear();
  }

  bool findFrombarcode(String barcode) {
    final item = _itens.where(
      (element) => element.codigoBarras == barcode,
    );

    if (item.isEmpty) {
      return false;
    }

    return true;
  }
}
