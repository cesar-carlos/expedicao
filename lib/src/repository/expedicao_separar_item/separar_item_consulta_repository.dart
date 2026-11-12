import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';

class SepararItemConsultaRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoSepararItemConsultaModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'separar.item.consulta',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoSepararItemConsultaModel.fromJson,
    );
  }
}
