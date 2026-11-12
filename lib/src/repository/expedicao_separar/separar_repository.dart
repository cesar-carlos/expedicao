import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_separar_model.dart';

class SepararRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoSepararModel>> select(QueryBuilder queryBuilder) {
    return _socket.queryMapped(
      eventSuffix: 'separar.select',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoSepararModel.fromJson,
    );
  }

  Future<List<ExpedicaoSepararModel>> insert(ExpedicaoSepararModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'separar.insert',
      mutation: entity.toJson(),
      fromJson: ExpedicaoSepararModel.fromJson,
    );
  }

  Future<List<ExpedicaoSepararModel>> update(ExpedicaoSepararModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'separar.update',
      mutation: entity.toJson(),
      fromJson: ExpedicaoSepararModel.fromJson,
    );
  }

  Future<List<ExpedicaoSepararModel>> delete(ExpedicaoSepararModel entity) {
    return _socket.mutateMapped(
      eventSuffix: 'separar.delete',
      mutation: entity.toJson(),
      fromJson: ExpedicaoSepararModel.fromJson,
    );
  }
}
