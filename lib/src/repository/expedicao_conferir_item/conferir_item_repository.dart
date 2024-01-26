import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_model.dart';

class ConferirItemRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoConferirItemModel>> select([String params = '']) {
    final event = '${socket.id} conferir.item.select';
    final completer = Completer<List<ExpedicaoConferirItemModel>>();
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

      final list = data.map<ExpedicaoConferirItemModel>((json) {
        return ExpedicaoConferirItemModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferirItemModel>> insert(
      ExpedicaoConferirItemModel entity) {
    final event = '${socket.id} conferir.item.insert';
    final completer = Completer<List<ExpedicaoConferirItemModel>>();
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

      final list = mutation.map<ExpedicaoConferirItemModel>((json) {
        return ExpedicaoConferirItemModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferirItemModel>> insertAll(
      List<ExpedicaoConferirItemModel> entity) {
    final event = '${socket.id} conferir.item.insert';
    final completer = Completer<List<ExpedicaoConferirItemModel>>();
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

      final list = mutation.map<ExpedicaoConferirItemModel>((json) {
        return ExpedicaoConferirItemModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferirItemModel>> update(
      ExpedicaoConferirItemModel entity) {
    final event = '${socket.id} conferir.item.update';
    final completer = Completer<List<ExpedicaoConferirItemModel>>();
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

      final list = mutation.map<ExpedicaoConferirItemModel>((json) {
        return ExpedicaoConferirItemModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferirItemModel>> updateAll(
      List<ExpedicaoConferirItemModel> entity) {
    final event = '${socket.id} conferir.item.update';
    final completer = Completer<List<ExpedicaoConferirItemModel>>();
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

      final list = mutation.map<ExpedicaoConferirItemModel>((json) {
        return ExpedicaoConferirItemModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferirItemModel>> delete(
      ExpedicaoConferirItemModel entity) {
    final event = '${socket.id} conferir.item.delete';
    final completer = Completer<List<ExpedicaoConferirItemModel>>();
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

      final list = mutation.map<ExpedicaoConferirItemModel>((json) {
        return ExpedicaoConferirItemModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferirItemModel>> deleteAll(
      List<ExpedicaoConferirItemModel> entity) {
    final event = '${socket.id} conferir.item.delete';
    final completer = Completer<List<ExpedicaoConferirItemModel>>();
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

      final list = mutation.map<ExpedicaoConferirItemModel>((json) {
        return ExpedicaoConferirItemModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }
}
