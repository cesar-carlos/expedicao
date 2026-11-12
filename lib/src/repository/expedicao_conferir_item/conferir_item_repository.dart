import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_model.dart';

class ConferirItemRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoConferirItemModel>> select(QueryBuilder queryBuilder) {
    return _socket.queryMapped(
      eventSuffix: 'conferir.item.select',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoConferirItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoConferirItemModel>> insert(
    ExpedicaoConferirItemModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'conferir.item.insert',
      mutation: entity.toJson(),
      fromJson: ExpedicaoConferirItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoConferirItemModel>> insertAll(
    List<ExpedicaoConferirItemModel> entitys,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'conferir.item.insert',
      mutation: entitys.map((el) => el.toJson()).toList(),
      fromJson: ExpedicaoConferirItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoConferirItemModel>> update(
    ExpedicaoConferirItemModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'conferir.item.update',
      mutation: entity.toJson(),
      fromJson: ExpedicaoConferirItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoConferirItemModel>> updateAll(
    List<ExpedicaoConferirItemModel> entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'conferir.item.update',
      mutation: entity.map((el) => el.toJson()).toList(),
      fromJson: ExpedicaoConferirItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoConferirItemModel>> delete(
    ExpedicaoConferirItemModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'conferir.item.delete',
      mutation: entity.toJson(),
      fromJson: ExpedicaoConferirItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoConferirItemModel>> deleteAll(
    List<ExpedicaoConferirItemModel> entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'conferir.item.delete',
      mutation: entity.map((el) => el.toJson()).toList(),
      fromJson: ExpedicaoConferirItemModel.fromJson,
    );
  }
}
