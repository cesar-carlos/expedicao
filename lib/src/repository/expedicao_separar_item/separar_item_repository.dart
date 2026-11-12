import 'package:get/get.dart';

import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_model.dart';

class SepararItemRepository {
  final _socket = Get.find<AppSocketConfig>();

  Future<List<ExpedicaoSepararItemModel>> select(QueryBuilder queryBuilder) {
    return _socket.queryMapped(
      eventSuffix: 'separar.item.select',
      queryBuilder: queryBuilder,
      fromJson: ExpedicaoSepararItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoSepararItemModel>> insert(
    ExpedicaoSepararItemModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'separar.item.insert',
      mutation: entity.toJson(),
      fromJson: ExpedicaoSepararItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoSepararItemModel>> insertAll(
    List<ExpedicaoSepararItemModel> entitys,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'separar.item.insert',
      mutation: entitys.map((el) => el.toJson()).toList(),
      fromJson: ExpedicaoSepararItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoSepararItemModel>> update(
    ExpedicaoSepararItemModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'separar.item.update',
      mutation: entity.toJson(),
      fromJson: ExpedicaoSepararItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoSepararItemModel>> updateAll(
    List<ExpedicaoSepararItemModel> entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'separar.item.update',
      mutation: entity.map((el) => el.toJson()).toList(),
      fromJson: ExpedicaoSepararItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoSepararItemModel>> delete(
    ExpedicaoSepararItemModel entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'separar.item.delete',
      mutation: entity.toJson(),
      fromJson: ExpedicaoSepararItemModel.fromJson,
    );
  }

  Future<List<ExpedicaoSepararItemModel>> deleteAll(
    List<ExpedicaoSepararItemModel> entity,
  ) {
    return _socket.mutateMapped(
      eventSuffix: 'separar.item.delete',
      mutation: entity.map((el) => el.toJson()).toList(),
      fromJson: ExpedicaoSepararItemModel.fromJson,
    );
  }
}
