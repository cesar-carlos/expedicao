import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/expedicao_cancelamento_model.dart';
import 'package:app_expedicao/src/app/app_socket.config.dart';

class CancelamentoRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoCancelamentoModel>> select([String params = '']) {
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

  Future<void> insert(ExpedicaoCancelamentoModel cancelamento) {
    final event = '${socket.id} cancelamento.insert';
    final completer = Completer<ExpedicaoCancelamentoModel>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": cancelamento.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'];
      final cancelamento = ExpedicaoCancelamentoModel.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(cancelamento);
    });

    return completer.future;
  }

  Future<void> update(ExpedicaoCancelamentoModel cancelamento) {
    final event = '${socket.id} cancelamento.update';
    final completer = Completer<ExpedicaoCancelamentoModel>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": cancelamento.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'];
      final cancelamento = ExpedicaoCancelamentoModel.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(cancelamento);
    });

    return completer.future;
  }

  Future<void> delete(ExpedicaoCancelamentoModel cancelamento) {
    final event = '${socket.id} cancelamento.delete';
    final completer = Completer<ExpedicaoCancelamentoModel>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": cancelamento.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'];
      final cancelamento = ExpedicaoCancelamentoModel.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(cancelamento);
    });

    return completer.future;
  }
}
