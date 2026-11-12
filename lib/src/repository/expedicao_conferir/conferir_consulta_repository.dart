import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';

class ConferirConsultaRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoConferirConsultaModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'conferir.consulta',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoConferirConsultaModel.fromJson,
    );
  }
}
