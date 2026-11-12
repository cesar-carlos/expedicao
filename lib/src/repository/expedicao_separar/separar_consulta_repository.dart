import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';

class SepararConsultaRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoSepararConsultaModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'separar.consulta',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoSepararConsultaModel.fromJson,
    );
  }
}
