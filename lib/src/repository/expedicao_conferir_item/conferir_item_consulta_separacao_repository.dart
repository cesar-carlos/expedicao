import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_separado_item_consulta_model.dart';

class ConferirItemConsultaSeparacaoRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoSeparadoItemConsultaModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'conferir.separacao.item.consulta',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoSeparadoItemConsultaModel.fromJson,
    );
  }
}
