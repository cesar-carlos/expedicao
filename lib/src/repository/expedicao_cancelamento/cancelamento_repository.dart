import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/expedicao_cancelamento_model.dart';
import 'package:app_expedicao/src/app/app_socket.config.dart';

class CancelamentoRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoCancelamentoModel>> select([String params = '']) {
    if (socket.connected == false) throw AppError('Socket não conectado');

    final event = '${socket.id} cancelamento.select';
    final completer = Completer<List<ExpedicaoCancelamentoModel>>();
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

      final list = data.map<ExpedicaoCancelamentoModel>((json) {
        return ExpedicaoCancelamentoModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoCancelamentoModel>> insert(
      ExpedicaoCancelamentoModel cancelamento) {
    if (socket.connected == false) throw AppError('Socket não conectado');

    final event = '${socket.id} cancelamento.insert';
    final completer = Completer<List<ExpedicaoCancelamentoModel>>();
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

      final list = mutation.map<ExpedicaoCancelamentoModel>((json) {
        return ExpedicaoCancelamentoModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoCancelamentoModel>> update(
      ExpedicaoCancelamentoModel cancelamento) {
    if (socket.connected == false) throw AppError('Socket não conectado');

    final event = '${socket.id} cancelamento.update';
    final completer = Completer<List<ExpedicaoCancelamentoModel>>();
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

      final list = mutation.map<ExpedicaoCancelamentoModel>((json) {
        return ExpedicaoCancelamentoModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoCancelamentoModel>> delete(
      ExpedicaoCancelamentoModel cancelamento) {
    if (socket.connected == false) throw AppError('Socket não conectado');

    final event = '${socket.id} cancelamento.delete';
    final completer = Completer<List<ExpedicaoCancelamentoModel>>();
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

      final list = mutation.map<ExpedicaoCancelamentoModel>((json) {
        return ExpedicaoCancelamentoModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }
}
