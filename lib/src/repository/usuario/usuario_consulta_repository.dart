import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/usuario_consulta.dart';

class UsuarioConsultaRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<UsuarioConsultaMoldel>> select(QueryBuilder queryBuilder) {
    return _socket.queryMapped(
      eventSuffix: 'usuario.consulta',
      queryBuilder: queryBuilder,
      fromJson: UsuarioConsultaMoldel.fromJson,
    );
  }
}
