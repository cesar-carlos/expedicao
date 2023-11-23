import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';

class SepararGridController extends GetxController {
  final RxList<ExpedicaoSepararItemConsultaModel> _itens = RxList.empty();

  List<ExpedicaoSepararItemConsultaModel> get itens => _itens;
  List<ExpedicaoSepararItemConsultaModel> get itensSort =>
      _itens.toList()..sort((a, b) => a.item.compareTo(b.item));

  addItem(ExpedicaoSepararItemConsultaModel item) {
    _itens.add(item);
  }

  removeItem(ExpedicaoSepararItemConsultaModel item) {
    _itens.remove(item);
  }

  updateItem(ExpedicaoSepararItemConsultaModel item) {
    final index = _itens.indexWhere((el) => el.item == item.item);
    _itens[index] = item;
  }

  removeAll() {
    _itens.clear();
  }

  bool findFrombarcode(String barcode) {
    final item = _itens.where(
      (el) => el.codigoBarras == barcode,
    );

    if (item.isEmpty) return false;
    return true;
  }

  bool findFromCodigo(int codigo) {
    final item = _itens.where(
      (el) => el.codProduto == codigo,
    );

    if (item.isEmpty) return false;
    return true;
  }
}
