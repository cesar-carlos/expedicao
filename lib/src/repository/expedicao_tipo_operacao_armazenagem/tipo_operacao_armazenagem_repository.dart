import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_tipo_operacao_armazenagem.dart';

class TipoOperacaoArmazenagemRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoTipoOperacaoArmazenagem>> select(
    QueryBuilder queryBuilder,
  ) {
    return _socket.queryMapped(
      eventSuffix: 'tipo.operacao.armazenagem.select',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoTipoOperacaoArmazenagem.fromJson,
    );
  }

  Future<List<ExpedicaoTipoOperacaoArmazenagem>> insert(
    ExpedicaoTipoOperacaoArmazenagem entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'tipo.operacao.armazenagem.insert',
      mutation: entity.toJson(),
      fromJson: ExpedicaoTipoOperacaoArmazenagem.fromJson,
    );
  }

  Future<List<ExpedicaoTipoOperacaoArmazenagem>> update(
    ExpedicaoTipoOperacaoArmazenagem entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'tipo.operacao.armazenagem.update',
      mutation: entity.toJson(),
      fromJson: ExpedicaoTipoOperacaoArmazenagem.fromJson,
    );
  }

  Future<List<ExpedicaoTipoOperacaoArmazenagem>> delete(
    ExpedicaoTipoOperacaoArmazenagem entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'tipo.operacao.armazenagem.delete',
      mutation: entity.toJson(),
      fromJson: ExpedicaoTipoOperacaoArmazenagem.fromJson,
    );
  }
}
