import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_consulta_model.dart';

class CarrinhoConsultaRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoCarrinhoConsultaModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'carrinho.consulta',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoCarrinhoConsultaModel.fromJson,
    );
  }
}
