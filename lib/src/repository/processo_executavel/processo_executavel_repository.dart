import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/app/app_socket.config.dart';

class ProcessoExecutavelRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ProcessoExecutavelModel>> select([String params = '']) {
    final event = '${socket.id} processo.executavel.select';
    final completer = Completer<List<ProcessoExecutavelModel>>();
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

      final list = data.map<ProcessoExecutavelModel>((json) {
        return ProcessoExecutavelModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ProcessoExecutavelModel>> insert(
      ProcessoExecutavelModel cancelamento) {
    final event = '${socket.id} processo.executavel.insert';
    final completer = Completer<List<ProcessoExecutavelModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": cancelamento.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ProcessoExecutavelModel>((json) {
        return ProcessoExecutavelModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ProcessoExecutavelModel>> update(
      ProcessoExecutavelModel cancelamento) {
    final event = '${socket.id} processo.executavel.update';
    final completer = Completer<List<ProcessoExecutavelModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": cancelamento.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ProcessoExecutavelModel>((json) {
        return ProcessoExecutavelModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ProcessoExecutavelModel>> delete(
      ProcessoExecutavelModel cancelamento) {
    final event = '${socket.id} processo.executavel.delete';
    final completer = Completer<List<ProcessoExecutavelModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": cancelamento.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ProcessoExecutavelModel>((json) {
        return ProcessoExecutavelModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }
}
