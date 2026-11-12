import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_armazenar_item.dart';

class ArmazenarItemRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoArmazenarItem>> select(QueryBuilder queryBuilder) {
    return _socket.queryMapped(
      eventSuffix: 'armazenar.item.select',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoArmazenarItem.fromJson,
    );
  }

  Future<List<ExpedicaoArmazenarItem>> insert(ExpedicaoArmazenarItem entity) {
    return _socket.mutateMapped(
      eventSuffix: 'armazenar.item.insert',
      mutation: entity.toJson(),
      fromJson: ExpedicaoArmazenarItem.fromJson,
    );
  }

  Future<List<ExpedicaoArmazenarItem>> insertAll(
    List<ExpedicaoArmazenarItem> entitys,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'armazenar.item.insert',
      mutation: entitys.map((el) => el.toJson()).toList(),
      fromJson: ExpedicaoArmazenarItem.fromJson,
    );
  }

  Future<List<ExpedicaoArmazenarItem>> update(ExpedicaoArmazenarItem entity) {
    return _socket.mutateMapped(
      eventSuffix: 'armazenar.item.update',
      mutation: entity.toJson(),
      fromJson: ExpedicaoArmazenarItem.fromJson,
    );
  }

  Future<List<ExpedicaoArmazenarItem>> updateAll(
    List<ExpedicaoArmazenarItem> entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'armazenar.item.update',
      mutation: entity.map((el) => el.toJson()).toList(),
      fromJson: ExpedicaoArmazenarItem.fromJson,
    );
  }

  Future<List<ExpedicaoArmazenarItem>> delete(ExpedicaoArmazenarItem entity) {
    return _socket.mutateMapped(
      eventSuffix: 'armazenar.item.delete',
      mutation: entity.toJson(),
      fromJson: ExpedicaoArmazenarItem.fromJson,
    );
  }
}
