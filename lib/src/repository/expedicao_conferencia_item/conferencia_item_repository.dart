import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_model.dart';

class ConferenciaItemRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoConferenciaItemModel>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'conferencia.item.select',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoConferenciaItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoConferenciaItemModel>> insert(
    ExpedicaoConferenciaItemModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'conferencia.item.insert',
      mutation: entity.toJson(),
      fromJson: ExpedicaoConferenciaItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoConferenciaItemModel>> insertAll(
    List<ExpedicaoConferenciaItemModel> entitys,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'conferencia.item.insert',
      mutation: entitys.map((el) => el.toJson()).toList(),
      fromJson: ExpedicaoConferenciaItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoConferenciaItemModel>> update(
    ExpedicaoConferenciaItemModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'conferencia.item.update',
      mutation: entity.toJson(),
      fromJson: ExpedicaoConferenciaItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoConferenciaItemModel>> updateAll(
    List<ExpedicaoConferenciaItemModel> entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'conferencia.item.update',
      mutation: entity.map((el) => el.toJson()).toList(),
      fromJson: ExpedicaoConferenciaItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoConferenciaItemModel>> delete(
    ExpedicaoConferenciaItemModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'conferencia.item.delete',
      mutation: entity.toJson(),
      fromJson: ExpedicaoConferenciaItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoConferenciaItemModel>> deleteAll(
    List<ExpedicaoConferenciaItemModel> entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'conferencia.item.delete',
      mutation: entity.map((el) => el.toJson()).toList(),
      fromJson: ExpedicaoConferenciaItemModel.fromJson,
    );
  }
}
