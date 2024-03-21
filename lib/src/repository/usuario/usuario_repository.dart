import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/model/usuario.model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class UsuarioRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<UsuarioModel>> select([String params = '']) {
    final event = '${socket.id} usuario.select';
    final completer = Completer<List<UsuarioModel>>();
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
        socket.off(resposeIn);

        if (data.isEmpty) {
          completer.complete([]);
          return;
        }

        final list = data.map<UsuarioModel>((json) {
          return UsuarioModel.fromJson(json);
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

  Future<List<UsuarioModel>> insert(UsuarioModel entity) {
    final event = '${socket.id} usuario.insert';
    final completer = Completer<List<UsuarioModel>>();
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

        final list = mutation.map<UsuarioModel>((json) {
          return UsuarioModel.fromJson(json);
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

  Future<List<UsuarioModel>> update(UsuarioModel entity) {
    final event = '${socket.id} usuario.update';
    final completer = Completer<List<UsuarioModel>>();
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

        final list = mutation.map<UsuarioModel>((json) {
          return UsuarioModel.fromJson(json);
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

  Future<List<UsuarioModel>> delete(UsuarioModel entity) {
    final event = '${socket.id} usuario.delete';
    final completer = Completer<List<UsuarioModel>>();
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

        final list = mutation.map<UsuarioModel>((json) {
          return UsuarioModel.fromJson(json);
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
