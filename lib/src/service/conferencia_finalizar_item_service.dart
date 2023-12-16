import 'package:app_expedicao/src/model/expedicao_conferencia_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_conferencia_item/conferencia_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';

class ConferenciaFinalizarItemService {
  Future<void> update(
    ExpedicaConferenciaItemConsultaModel item,
  ) async {
    final conferenciaItem = ExpedicaoConferenciaItemModel.fromConsulta(item)
        .copyWith(situacao: ExpedicaoItemSituacaoModel.finalizado);
    await ConferenciaItemRepository().update(conferenciaItem);
  }

  Future<void> updateAll(
    List<ExpedicaConferenciaItemConsultaModel> itens,
  ) async {
    final conferenciaItens = itens
        .map((el) => ExpedicaoConferenciaItemModel.fromConsulta(el)
            .copyWith(situacao: ExpedicaoItemSituacaoModel.finalizado))
        .toList();

    await ConferenciaItemRepository().updateAll(conferenciaItens);
  }
}
