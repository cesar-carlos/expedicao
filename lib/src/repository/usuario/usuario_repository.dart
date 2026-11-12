import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/usuario.model.dart';

class UsuarioRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<UsuarioModel>> select(QueryBuilder queryBuilder) {
    return _socket.queryMapped(
      eventSuffix: 'usuario.select',
      queryBuilder: queryBuilder,
      fromJson: UsuarioModel.fromJson,
    );
  }

  Future<List<UsuarioModel>> insert(UsuarioModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'usuario.insert',
      mutation: entity.toJson(),
      fromJson: UsuarioModel.fromJson,
    );
  }

  Future<List<UsuarioModel>> update(UsuarioModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'usuario.update',
      mutation: entity.toJson(),
      fromJson: UsuarioModel.fromJson,
    );
  }

  Future<List<UsuarioModel>> delete(UsuarioModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'usuario.delete',
      mutation: entity.toJson(),
      fromJson: UsuarioModel.fromJson,
    );
  }
}
