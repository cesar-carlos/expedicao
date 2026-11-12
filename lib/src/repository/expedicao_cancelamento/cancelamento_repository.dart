import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_cancelamento_model.dart';

class CancelamentoRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoCancelamentoModel>> select(QueryBuilder queryBuilder) {
    return _socket.queryMapped(
      eventSuffix: 'expedicao.cancelamento.select',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoCancelamentoModel.fromJson,
    );
  }

  Future<List<ExpedicaoCancelamentoModel>> insert(
    ExpedicaoCancelamentoModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'expedicao.cancelamento.insert',
      mutation: entity.toJson(),
      fromJson: ExpedicaoCancelamentoModel.fromJson,
    );
  }

  Future<List<ExpedicaoCancelamentoModel>> update(
    ExpedicaoCancelamentoModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'expedicao.cancelamento.update',
      mutation: entity.toJson(),
      fromJson: ExpedicaoCancelamentoModel.fromJson,
    );
  }

  Future<List<ExpedicaoCancelamentoModel>> delete(
    ExpedicaoCancelamentoModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'expedicao.cancelamento.delete',
      mutation: entity.toJson(),
      fromJson: ExpedicaoCancelamentoModel.fromJson,
    );
  }
}
