import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/estoque_produto_conversao_unidade_consulta_model.dart';

class EstoqueProdutoConversaoUnidadeConsultaRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<EstoqueProdutoConversaoUnidadeConsultaModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'produto.conversao.unidade.consulta',
      queryBuilder: queryBuilder,
      fromJson: EstoqueProdutoConversaoUnidadeConsultaModel.fromJson,
    );
  }
}
