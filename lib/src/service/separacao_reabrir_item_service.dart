import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';

class SeparacaoReabrirItemService {
  Future<void> updateAll(List<ExpedicaSeparacaoItemConsultaModel> itens) async {
    final separacaoItens = itens
        .map(
          (el) =>
              ExpedicaoSeparacaoItemModel.fromConsulta(el)
                  .copyWith(situacao: ExpedicaoItemSituacaoModel.separado),
        )
        .toList();

    await SeparacaoItemRepository().updateAll(separacaoItens);
  }
}
