import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';

class CarrinhoPercursoRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoCarrinhoPercursoModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'carrinho.percurso.select',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoCarrinhoPercursoModel.fromJson,
    );
  }

  Future<List<ExpedicaoCarrinhoPercursoModel>> insert(
    ExpedicaoCarrinhoPercursoModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'carrinho.percurso.insert',
      mutation: entity.toJson(),
      fromJson: ExpedicaoCarrinhoPercursoModel.fromJson,
    );
  }

  Future<List<ExpedicaoCarrinhoPercursoModel>> update(
    ExpedicaoCarrinhoPercursoModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'carrinho.percurso.update',
      mutation: entity.toJson(),
      fromJson: ExpedicaoCarrinhoPercursoModel.fromJson,
    );
  }

  Future<List<ExpedicaoCarrinhoPercursoModel>> delete(
    ExpedicaoCarrinhoPercursoModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'carrinho.percurso.delete',
      mutation: entity.toJson(),
      fromJson: ExpedicaoCarrinhoPercursoModel.fromJson,
    );
  }
}
