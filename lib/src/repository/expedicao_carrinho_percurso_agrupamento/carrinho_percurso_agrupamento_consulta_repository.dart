import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_consulta_model.dart';

class CarrinhoPercursoAgrupamentoConsultaRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'carrinho.percurso.agrupamento.consulta',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel.fromJson,
    );
  }
}
