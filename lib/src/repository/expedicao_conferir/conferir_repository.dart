import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_model.dart';

class ConferirRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoConferirModel>> select(QueryBuilder queryBuilder) {
    return _socket.queryMapped(
      eventSuffix: 'conferir.select',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoConferirModel.fromJson,
    );
  }

  Future<List<ExpedicaoConferirModel>> insert(ExpedicaoConferirModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'conferir.insert',
      mutation: entity.toJson(),
      fromJson: ExpedicaoConferirModel.fromJson,
    );
  }

  Future<List<ExpedicaoConferirModel>> update(ExpedicaoConferirModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'conferir.update',
      mutation: entity.toJson(),
      fromJson: ExpedicaoConferirModel.fromJson,
    );
  }

  Future<List<ExpedicaoConferirModel>> delete(ExpedicaoConferirModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'conferir.delete',
      mutation: entity.toJson(),
      fromJson: ExpedicaoConferirModel.fromJson,
    );
  }
}
