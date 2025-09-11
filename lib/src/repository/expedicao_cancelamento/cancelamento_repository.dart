import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_cancelamento_model.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class CancelamentoRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoCancelamentoModel>> select([String params = '']) {
    final event = '${socket.id} cancelamento.select';
    final completer = Completer<List<ExpedicaoCancelamentoModel>>();
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

        final list = data.map<ExpedicaoCancelamentoModel>((json) {
          return ExpedicaoCancelamentoModel.fromJson(json);
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

  Future<List<ExpedicaoCancelamentoModel>> insert(
      ExpedicaoCancelamentoModel entity) {
    final event = '${socket.id} cancelamento.insert';
    final completer = Completer<List<ExpedicaoCancelamentoModel>>();
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

        final list = mutation.map<ExpedicaoCancelamentoModel>((json) {
          return ExpedicaoCancelamentoModel.fromJson(json);
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

  Future<List<ExpedicaoCancelamentoModel>> update(
      ExpedicaoCancelamentoModel entity) {
    final event = '${socket.id} cancelamento.update';
    final completer = Completer<List<ExpedicaoCancelamentoModel>>();
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

        final list = mutation.map<ExpedicaoCancelamentoModel>((json) {
          return ExpedicaoCancelamentoModel.fromJson(json);
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

  Future<List<ExpedicaoCancelamentoModel>> delete(
      ExpedicaoCancelamentoModel entity) {
    final event = '${socket.id} cancelamento.delete';
    final completer = Completer<List<ExpedicaoCancelamentoModel>>();
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

        final list = mutation.map<ExpedicaoCancelamentoModel>((json) {
          return ExpedicaoCancelamentoModel.fromJson(json);
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
