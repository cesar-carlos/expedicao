import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_unidade_medida_consulta_model.dart';

class ConferirItemUnidadeMedidaConsultaRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoConferirItemUnidadeMedidaConsultaModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'conferir.item.unidade.medida.consulta',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoConferirItemUnidadeMedidaConsultaModel.fromJson,
    );
  }
}
