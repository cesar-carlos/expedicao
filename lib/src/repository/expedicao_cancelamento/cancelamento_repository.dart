import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_cancelamento_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class CancelamentoRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoCancelamentoModel>> select([String params = '']) {
    final event = '${socket.id} cancelamento.select';
    final completer = Completer<List<ExpedicaoCancelamentoModel>>();
    final resposeIn = uuid.v4();

    final send = SendQuerySocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      where: params,
    );

    try {
      socket.emit(event, jsonEncode(send.toJson()));
      socket.on(resposeIn, (receiver) {
        final data = jsonDecode(receiver) as List<dynamic>;
        //final error = data?['error'] ?? null;
        socket.off(resposeIn);

        if (data.isEmpty) {
          completer.complete([]);
          return;
        }

        final list = data.map<ExpedicaoCancelamentoModel>((json) {
          return ExpedicaoCancelamentoModel.fromJson(json);
        }).toList();

        completer.complete(list);
      });

      return completer.future;
    } catch (e) {
      socket.off(resposeIn);
      completer.completeError(AppError(e.toString()));
      return completer.future;
    }
  }

  Future<List<ExpedicaoCancelamentoModel>> insert(
      ExpedicaoCancelamentoModel entity) {
    final event = '${socket.id} cancelamento.insert';
    final completer = Completer<List<ExpedicaoCancelamentoModel>>();
    final resposeIn = uuid.v4();

    final send = SendMutationSocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      mutation: entity.toJson(),
    );

    try {
      socket.emit(event, jsonEncode(send.toJson()));
      socket.on(resposeIn, (receiver) {
        final data = jsonDecode(receiver);
        final mutation = data?['mutation'] ?? [];
        final error = data?['error'] ?? null;
        socket.off(resposeIn);

        if (error != null) {
          completer.completeError(AppError(error));
          return;
        }

        final list = mutation.map<ExpedicaoCancelamentoModel>((json) {
          return ExpedicaoCancelamentoModel.fromJson(json);
        }).toList();

        completer.complete(list);
      });

      return completer.future;
    } catch (e) {
      socket.off(resposeIn);
      completer.completeError(AppError(e.toString()));
      return completer.future;
    }
  }

  Future<List<ExpedicaoCancelamentoModel>> update(
      ExpedicaoCancelamentoModel entity) {
    final event = '${socket.id} cancelamento.update';
    final completer = Completer<List<ExpedicaoCancelamentoModel>>();
    final resposeIn = uuid.v4();

    final send = SendMutationSocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      mutation: entity.toJson(),
    );

    try {
      socket.emit(event, jsonEncode(send.toJson()));
      socket.on(resposeIn, (receiver) {
        final data = jsonDecode(receiver);
        final mutation = data?['mutation'] ?? [];
        final error = data?['error'] ?? null;
        socket.off(resposeIn);

        if (error != null) {
          completer.completeError(AppError(error));
          return;
        }

        final list = mutation.map<ExpedicaoCancelamentoModel>((json) {
          return ExpedicaoCancelamentoModel.fromJson(json);
        }).toList();

        completer.complete(list);
      });

      return completer.future;
    } catch (e) {
      socket.off(resposeIn);
      completer.completeError(AppError(e.toString()));
      return completer.future;
    }
  }

  Future<List<ExpedicaoCancelamentoModel>> delete(
      ExpedicaoCancelamentoModel entity) {
    final event = '${socket.id} cancelamento.delete';
    final completer = Completer<List<ExpedicaoCancelamentoModel>>();
    final resposeIn = uuid.v4();

    final send = SendMutationSocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      mutation: entity.toJson(),
    );

    try {
      socket.emit(event, jsonEncode(send.toJson()));
      socket.on(resposeIn, (receiver) {
        final data = jsonDecode(receiver);
        final mutation = data?['mutation'] ?? [];
        final error = data?['error'] ?? null;

        if (error != null) {
          completer.completeError(AppError(error));
          return;
        }

        final list = mutation.map<ExpedicaoCancelamentoModel>((json) {
          return ExpedicaoCancelamentoModel.fromJson(json);
        }).toList();

        completer.complete(list);
      });

      return completer.future;
    } catch (e) {
      socket.off(resposeIn);
      completer.completeError(AppError(e.toString()));
      return completer.future;
    }
  }
}
