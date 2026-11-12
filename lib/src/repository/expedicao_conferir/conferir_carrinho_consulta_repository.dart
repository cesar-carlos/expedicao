import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_conferir_consulta_model.dart';

class ConferirCarrinhoConsultaRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoCarrinhoConferirConsultaModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'carrinho.conferir.consulta',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoCarrinhoConferirConsultaModel.fromJson,
    );
  }
}
