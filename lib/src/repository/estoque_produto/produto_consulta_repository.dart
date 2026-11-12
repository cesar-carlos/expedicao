import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/estoque_produto_consulta_model.dart';

class EstoqueProdutoConsultaRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<EstoqueProdutoConsultaModel>> select(QueryBuilder queryBuilder) {
    return _socket.queryMapped(
      eventSuffix: 'estoque.produto.consulta',
      queryBuilder: queryBuilder,
      fromJson: EstoqueProdutoConsultaModel.fromJson,
    );
  }
}
