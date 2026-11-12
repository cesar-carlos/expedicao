import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';

class CarrinhoRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoCarrinhoModel>> select(QueryBuilder queryBuilder) {
    return _socket.queryMapped(
      eventSuffix: 'carrinho.select',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoCarrinhoModel.fromJson,
    );
  }

  Future<List<ExpedicaoCarrinhoModel>> insert(ExpedicaoCarrinhoModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'carrinho.insert',
      mutation: entity.toJson(),
      fromJson: ExpedicaoCarrinhoModel.fromJson,
    );
  }

  Future<List<ExpedicaoCarrinhoModel>> update(ExpedicaoCarrinhoModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'carrinho.update',
      mutation: entity.toJson(),
      fromJson: ExpedicaoCarrinhoModel.fromJson,
    );
  }

  Future<List<ExpedicaoCarrinhoModel>> delete(ExpedicaoCarrinhoModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'carrinho.delete',
      mutation: entity.toJson(),
      fromJson: ExpedicaoCarrinhoModel.fromJson,
    );
  }
}
