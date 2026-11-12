import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_armazenar.dart';

class ArmazenarRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoArmazenar>> select(QueryBuilder queryBuilder) {
    return _socket.queryMapped(
      eventSuffix: 'armazenar.select',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoArmazenar.fromJson,
    );
  }

  Future<List<ExpedicaoArmazenar>> insert(ExpedicaoArmazenar entity) {
    return _socket.mutateMapped(
      eventSuffix: 'armazenar.insert',
      mutation: entity.toJson(),
      fromJson: ExpedicaoArmazenar.fromJson,
    );
  }

  Future<List<ExpedicaoArmazenar>> update(ExpedicaoArmazenar entity) {
    return _socket.mutateMapped(
      eventSuffix: 'armazenar.update',
      mutation: entity.toJson(),
      fromJson: ExpedicaoArmazenar.fromJson,
    );
  }

  Future<List<ExpedicaoArmazenar>> delete(ExpedicaoArmazenar entity) {
    return _socket.mutateMapped(
      eventSuffix: 'armazenar.delete',
      mutation: entity.toJson(),
      fromJson: ExpedicaoArmazenar.fromJson,
    );
  }
}
