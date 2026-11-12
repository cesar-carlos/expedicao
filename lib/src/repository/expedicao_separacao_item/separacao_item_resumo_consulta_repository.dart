import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_resumo.consulta_model.dart';

class SeparacaoItemResumoConsultaRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaSeparacaoItemResumoConsultaModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'separacao.item.resumo.consulta',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaSeparacaoItemResumoConsultaModel.fromJson,
    );
  }
}
