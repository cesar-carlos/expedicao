import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';

class SeparacaoItemRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoSeparacaoItemModel>> select(QueryBuilder queryBuilder) {
    return _socket.queryMapped(
      eventSuffix: 'separacao.item.select',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoSeparacaoItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoSeparacaoItemModel>> insert(
    ExpedicaoSeparacaoItemModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'separacao.item.insert',
      mutation: entity.toJson(),
      fromJson: ExpedicaoSeparacaoItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoSeparacaoItemModel>> insertAll(
    List<ExpedicaoSeparacaoItemModel> entitys,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'separacao.item.insert',
      mutation: entitys.map((el) => el.toJson()).toList(),
      fromJson: ExpedicaoSeparacaoItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoSeparacaoItemModel>> update(
    ExpedicaoSeparacaoItemModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'separacao.item.update',
      mutation: entity.toJson(),
      fromJson: ExpedicaoSeparacaoItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoSeparacaoItemModel>> updateAll(
    List<ExpedicaoSeparacaoItemModel> entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'separacao.item.update',
      mutation: entity.map((el) => el.toJson()).toList(),
      fromJson: ExpedicaoSeparacaoItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoSeparacaoItemModel>> delete(
    ExpedicaoSeparacaoItemModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'separacao.item.delete',
      mutation: entity.toJson(),
      fromJson: ExpedicaoSeparacaoItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoSeparacaoItemModel>> deleteAll(
    List<ExpedicaoSeparacaoItemModel> entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'separacao.item.delete',
      mutation: entity.map((el) => el.toJson()).toList(),
      fromJson: ExpedicaoSeparacaoItemModel.fromJson,
    );
  }
}
