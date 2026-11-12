import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_consulta_model.dart';

class ConferirItemConsultaRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoConferirItemConsultaModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'conferir.item.consulta',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoConferirItemConsultaModel.fromJson,
    );
  }
}
