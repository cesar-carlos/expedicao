import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';

class SeparacaoFinalizarItemService {
  // final _socket = Get.find<AppSocketConfig>().socket;
  // final _processo = Get.find<ProcessoExecutavelModel>();

  Future<void> update(
    ExpedicaSeparacaoItemConsultaModel item,
  ) async {
    final separacaoItem = ExpedicaoSeparacaoItemModel.fromConsulta(item)
        .copyWith(situacao: ExpedicaoItemSituacaoModel.finalizado);
    await SeparacaoItemRepository().update(separacaoItem);
  }

  Future<void> updateAll(
    List<ExpedicaSeparacaoItemConsultaModel> itens,
  ) async {
    final separacaoItens = itens
        .map((el) => ExpedicaoSeparacaoItemModel.fromConsulta(el)
            .copyWith(situacao: ExpedicaoItemSituacaoModel.finalizado))
        .toList();

    await SeparacaoItemRepository().updateAll(separacaoItens);
  }
}
