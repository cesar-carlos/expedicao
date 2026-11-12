import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_unidade_medida_consulta_model.dart';

class SepararItemUnidadeMedidaConsultaRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoSepararItemUnidadeMedidaConsultaModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'separar.item.unidade.medida.consulta',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoSepararItemUnidadeMedidaConsultaModel.fromJson,
    );
  }
}
