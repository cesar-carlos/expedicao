import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class ProcessoExecutavelRepository {
  final uuid = const Uuid();
  final socket = Get.find<AppSocketConfig>().socket;

  Future<List<ProcessoExecutavelModel>> select([String params = '']) {
    final event = '${socket.id} processo.executavel.select';
    final completer = Completer<List<ProcessoExecutavelModel>>();
    final resposeIn = uuid.v4();

    final send = SendQuerySocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      where: params,
    );

    try {
      socket.emit(event, jsonEncode(send.toJson()));
      socket.on(resposeIn, (receiver) {
        final data = jsonDecode(receiver);
        socket.off(resposeIn);

        if (data.isEmpty) {
          completer.complete([]);
          return;
        }

        final list = data.map<ProcessoExecutavelModel>((json) {
          return ProcessoExecutavelModel.fromJson(json);
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

  Future<List<ProcessoExecutavelModel>> insert(ProcessoExecutavelModel entity) {
    final event = '${socket.id} processo.executavel.insert';
    final completer = Completer<List<ProcessoExecutavelModel>>();
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
          completer.completeError(error);
          return;
        }

        final list = mutation.map<ProcessoExecutavelModel>((json) {
          return ProcessoExecutavelModel.fromJson(json);
        }).toList();

        completer.complete(list);
        return;
      });

      return completer.future;
    } catch (e) {
      socket.off(resposeIn);
      completer.completeError(AppError(e.toString()));
      return completer.future;
    }
  }

  Future<List<ProcessoExecutavelModel>> update(ProcessoExecutavelModel entity) {
    final event = '${socket.id} processo.executavel.update';
    final completer = Completer<List<ProcessoExecutavelModel>>();
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
          completer.completeError(error);
          return;
        }

        final list = mutation.map<ProcessoExecutavelModel>((json) {
          return ProcessoExecutavelModel.fromJson(json);
        }).toList();

        completer.complete(list);
        return;
      });

      return completer.future;
    } catch (e) {
      socket.off(resposeIn);
      completer.completeError(AppError(e.toString()));
      return completer.future;
    }
  }

  Future<List<ProcessoExecutavelModel>> delete(ProcessoExecutavelModel entity) {
    final event = '${socket.id} processo.executavel.delete';
    final completer = Completer<List<ProcessoExecutavelModel>>();
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
          completer.completeError(error);
          return;
        }

        final list = mutation.map<ProcessoExecutavelModel>((json) {
          return ProcessoExecutavelModel.fromJson(json);
        }).toList();

        completer.complete(list);
        return;
      });

      return completer.future;
    } catch (e) {
      socket.off(resposeIn);
      completer.completeError(AppError(e.toString()));
      return completer.future;
    }
  }
}
