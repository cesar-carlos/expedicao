import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_model.dart';

class ConferenciaItemRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoConferenciaItemModel>> select([String params = '']) {
    final event = '${socket.id} conferencia.item.select';
    final completer = Completer<List<ExpedicaoConferenciaItemModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "where": params,
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);

      if (data.isEmpty) {
        completer.complete([]);
        socket.off(resposeIn);
        return;
      }

      final list = data.map<ExpedicaoConferenciaItemModel>((json) {
        return ExpedicaoConferenciaItemModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferenciaItemModel>> insert(
      ExpedicaoConferenciaItemModel entity) {
    final event = '${socket.id} conferencia.item.insert';
    final completer = Completer<List<ExpedicaoConferenciaItemModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": entity.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
        return ExpedicaoConferenciaItemModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferenciaItemModel>> insertAll(
      List<ExpedicaoConferenciaItemModel> entity) {
    final event = '${socket.id} conferencia.item.insert';
    final completer = Completer<List<ExpedicaoConferenciaItemModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": entity.map((el) => el.toJson()).toList(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
        return ExpedicaoConferenciaItemModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferenciaItemModel>> update(
      ExpedicaoConferenciaItemModel entity) {
    final event = '${socket.id} conferencia.item.update';
    final completer = Completer<List<ExpedicaoConferenciaItemModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": entity.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
        return ExpedicaoConferenciaItemModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferenciaItemModel>> updateAll(
      List<ExpedicaoConferenciaItemModel> entity) {
    final event = '${socket.id} conferencia.item.update';
    final completer = Completer<List<ExpedicaoConferenciaItemModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": entity.map((el) => el.toJson()).toList(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
        return ExpedicaoConferenciaItemModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferenciaItemModel>> delete(
      ExpedicaoConferenciaItemModel entity) {
    final event = '${socket.id} conferencia.item.delete';
    final completer = Completer<List<ExpedicaoConferenciaItemModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": entity.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
        return ExpedicaoConferenciaItemModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferenciaItemModel>> deleteAll(
      List<ExpedicaoConferenciaItemModel> entity) {
    final event = '${socket.id} conferencia.item.delete';
    final completer = Completer<List<ExpedicaoConferenciaItemModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": entity.map((el) => el.toJson()).toList(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
        return ExpedicaoConferenciaItemModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }
}
