import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_estagio_model.dart';

class ExpedicaoEstagioRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoEstagioModel>> select(QueryBuilder queryBuilder) {
    return _socket.queryMapped(
      eventSuffix: 'expedicao.percurso.estagio.select',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoEstagioModel.fromJson,
    );
  }

  Future<List<ExpedicaoEstagioModel>> insert(ExpedicaoEstagioModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'expedicao.percurso.estagio.insert',
      mutation: entity.toJson(),
      fromJson: ExpedicaoEstagioModel.fromJson,
    );
  }

  Future<List<ExpedicaoEstagioModel>> update(ExpedicaoEstagioModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'expedicao.percurso.estagio.update',
      mutation: entity.toJson(),
      fromJson: ExpedicaoEstagioModel.fromJson,
    );
  }

  Future<List<ExpedicaoEstagioModel>> delete(ExpedicaoEstagioModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'expedicao.percurso.estagio.delete',
      mutation: entity.toJson(),
      fromJson: ExpedicaoEstagioModel.fromJson,
    );
  }
}
