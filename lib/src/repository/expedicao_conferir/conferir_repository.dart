import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class ConferirRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoConferirModel>> select([String params = '']) {
    final event = '${socket.id} conferir.select';
    final completer = Completer<List<ExpedicaoConferirModel>>();
    final responseIn = uuid.v4();

    final send = SendQuerySocketModel(
      session: socket.id!,
      responseIn: responseIn,
      where: params,
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(responseIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final error = respose?['Error'] ?? null;
        final data = respose?['Data'] ?? [];

        if (error != null) throw error;

        final list = data.map<ExpedicaoConferirModel>((json) {
          return ExpedicaoConferirModel.fromJson(json);
        }).toList();

        completer.complete(list);
      } catch (e) {
        completer.completeError(AppError(e.toString()));
        return completer.future;
      } finally {
        socket.off(responseIn);
      }
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferirModel>> insert(ExpedicaoConferirModel entity) {
    final event = '${socket.id} conferir.insert';
    final completer = Completer<List<ExpedicaoConferirModel>>();
    final responseIn = uuid.v4();

    final send = SendMutationSocketModel(
      session: socket.id!,
      responseIn: responseIn,
      mutation: entity.toJson(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(responseIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoConferirModel>((json) {
          return ExpedicaoConferirModel.fromJson(json);
        }).toList();

        completer.complete(list);
      } catch (e) {
        completer.completeError(AppError(e.toString()));
        return completer.future;
      } finally {
        socket.off(responseIn);
      }
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferirModel>> update(ExpedicaoConferirModel entity) {
    final event = '${socket.id} conferir.update';
    final completer = Completer<List<ExpedicaoConferirModel>>();
    final responseIn = uuid.v4();

    final send = SendMutationSocketModel(
      session: socket.id!,
      responseIn: responseIn,
      mutation: entity.toJson(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(responseIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoConferirModel>((json) {
          return ExpedicaoConferirModel.fromJson(json);
        }).toList();

        completer.complete(list);
      } catch (e) {
        completer.completeError(AppError(e.toString()));
        return completer.future;
      } finally {
        socket.off(responseIn);
      }
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferirModel>> delete(ExpedicaoConferirModel entity) {
    final event = '${socket.id} conferir.delete';
    final completer = Completer<List<ExpedicaoConferirModel>>();
    final responseIn = uuid.v4();

    final send = SendMutationSocketModel(
      session: socket.id!,
      responseIn: responseIn,
      mutation: entity.toJson(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(responseIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoConferirModel>((json) {
          return ExpedicaoConferirModel.fromJson(json);
        }).toList();

        completer.complete(list);
      } catch (e) {
        completer.completeError(AppError(e.toString()));
        return completer.future;
      } finally {
        socket.off(responseIn);
      }
    });

    return completer.future;
  }
}
