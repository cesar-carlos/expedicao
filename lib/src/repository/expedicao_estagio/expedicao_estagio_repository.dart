import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/expedicao_estagio_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class ExpedicaoEstagioRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoEstagioModel>> select([String params = '']) {
    final event = '${socket.id} expedicao.estagio.select';
    final completer = Completer<List<ExpedicaoEstagioModel>>();
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

      final list = data.map<ExpedicaoEstagioModel>((json) {
        return ExpedicaoEstagioModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoEstagioModel>> insert(ExpedicaoEstagioModel carrinho) {
    final event = '${socket.id} expedicao.estagio.insert';
    final completer = Completer<List<ExpedicaoEstagioModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": carrinho.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ExpedicaoEstagioModel>((json) {
        return ExpedicaoEstagioModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoEstagioModel>> update(ExpedicaoEstagioModel carrinho) {
    final event = '${socket.id} expedicao.estagio.update';
    final completer = Completer<List<ExpedicaoEstagioModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": carrinho.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ExpedicaoEstagioModel>((json) {
        return ExpedicaoEstagioModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoEstagioModel>> delete(ExpedicaoEstagioModel carrinho) {
    final event = '${socket.id} expedicao.estagio.delete';
    final completer = Completer<List<ExpedicaoEstagioModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": carrinho.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ExpedicaoEstagioModel>((json) {
        return ExpedicaoEstagioModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }
}
