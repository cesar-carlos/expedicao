import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_model.dart';

class CarrinhoPercursoAgrupamentoRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'carrinho.percurso.agrupamento.select',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoCarrinhoPercursoAgrupamentoModel.fromJson,
    );
  }

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoModel>> insert(
    ExpedicaoCarrinhoPercursoAgrupamentoModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'carrinho.percurso.agrupamento.insert',
      mutation: entity.toJson(),
      fromJson: ExpedicaoCarrinhoPercursoAgrupamentoModel.fromJson,
    );
  }

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoModel>> update(
    ExpedicaoCarrinhoPercursoAgrupamentoModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'carrinho.percurso.agrupamento.update',
      mutation: entity.toJson(),
      fromJson: ExpedicaoCarrinhoPercursoAgrupamentoModel.fromJson,
    );
  }

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoModel>> delete(
    ExpedicaoCarrinhoPercursoAgrupamentoModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'carrinho.percurso.agrupamento.delete',
      mutation: entity.toJson(),
      fromJson: ExpedicaoCarrinhoPercursoAgrupamentoModel.fromJson,
    );
  }
}
