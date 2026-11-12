import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';

class ProcessoExecutavelRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ProcessoExecutavelModel>> select(QueryBuilder queryBuilder) {
    return _socket.queryMapped(
      eventSuffix: 'processo.executavel.select',
      queryBuilder: queryBuilder,
      fromJson: ProcessoExecutavelModel.fromJson,
    );
  }

  Future<List<ProcessoExecutavelModel>> insert(ProcessoExecutavelModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'processo.executavel.insert',
      mutation: entity.toJson(),
      fromJson: ProcessoExecutavelModel.fromJson,
    );
  }

  Future<List<ProcessoExecutavelModel>> update(ProcessoExecutavelModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'processo.executavel.update',
      mutation: entity.toJson(),
      fromJson: ProcessoExecutavelModel.fromJson,
    );
  }

  Future<List<ProcessoExecutavelModel>> delete(ProcessoExecutavelModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'processo.executavel.delete',
      mutation: entity.toJson(),
      fromJson: ProcessoExecutavelModel.fromJson,
    );
  }
}
