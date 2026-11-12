import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_tipo_operacao_model.dart';

class TipoOperacaoRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoTipoOperacaoModel>> select(QueryBuilder queryBuilder) {
    return _socket.queryMapped(
      eventSuffix: 'tipo.operacao.expedicao.select',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoTipoOperacaoModel.fromJson,
    );
  }

  Future<List<ExpedicaoTipoOperacaoModel>> insert(
    ExpedicaoTipoOperacaoModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'tipo.operacao.expedicao.insert',
      mutation: entity.toJson(),
      fromJson: ExpedicaoTipoOperacaoModel.fromJson,
    );
  }

  Future<List<ExpedicaoTipoOperacaoModel>> update(
    ExpedicaoTipoOperacaoModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'tipo.operacao.expedicao.update',
      mutation: entity.toJson(),
      fromJson: ExpedicaoTipoOperacaoModel.fromJson,
    );
  }

  Future<List<ExpedicaoTipoOperacaoModel>> delete(
    ExpedicaoTipoOperacaoModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'tipo.operacao.expedicao.delete',
      mutation: entity.toJson(),
      fromJson: ExpedicaoTipoOperacaoModel.fromJson,
    );
  }
}
