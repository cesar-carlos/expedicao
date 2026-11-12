import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';

class CarrinhoPercursoEstagioConsultaRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoCarrinhoPercursoEstagioConsultaModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'carrinho.percurso.estagio.consulta',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoCarrinhoPercursoEstagioConsultaModel.fromJson,
    );
  }
}
