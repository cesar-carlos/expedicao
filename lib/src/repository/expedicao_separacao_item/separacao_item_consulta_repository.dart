import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';

class SeparacaoItemConsultaRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaSeparacaoItemConsultaModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'separacao.item.consulta',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaSeparacaoItemConsultaModel.fromJson,
    );
  }
}
