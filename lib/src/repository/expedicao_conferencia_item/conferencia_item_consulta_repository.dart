import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_consulta_model.dart';

class ConferenciaItemConsultaRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaConferenciaItemConsultaModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'conferencia.item.consulta',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaConferenciaItemConsultaModel.fromJson,
    );
  }
}
