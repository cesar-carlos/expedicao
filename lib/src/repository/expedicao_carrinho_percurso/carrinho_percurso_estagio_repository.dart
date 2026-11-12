import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_model.dart';

class CarrinhoPercursoEstagioRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoCarrinhoPercursoEstagioModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'carrinho.percurso.estagio.select',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoCarrinhoPercursoEstagioModel.fromJson,
    );
  }

  Future<List<ExpedicaoCarrinhoPercursoEstagioModel>> insert(
    ExpedicaoCarrinhoPercursoEstagioModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'carrinho.percurso.estagio.insert',
      mutation: entity.toJson(),
      fromJson: ExpedicaoCarrinhoPercursoEstagioModel.fromJson,
    );
  }

  Future<List<ExpedicaoCarrinhoPercursoEstagioModel>> update(
    ExpedicaoCarrinhoPercursoEstagioModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'carrinho.percurso.estagio.update',
      mutation: entity.toJson(),
      fromJson: ExpedicaoCarrinhoPercursoEstagioModel.fromJson,
    );
  }

  Future<List<ExpedicaoCarrinhoPercursoEstagioModel>> delete(
    ExpedicaoCarrinhoPercursoEstagioModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'carrinho.percurso.estagio.delete',
      mutation: entity.toJson(),
      fromJson: ExpedicaoCarrinhoPercursoEstagioModel.fromJson,
    );
  }
}
