import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_model.dart';
import 'package:app_expedicao/src/model/send_mutations_socket_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class ConferenciaItemRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoConferenciaItemModel>> select([String params = '']) {
    final event = '${socket.id} conferencia.item.select';
    final completer = Completer<List<ExpedicaoConferenciaItemModel>>();
    final resposeIn = uuid.v4();

    final send = SendQuerySocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      where: params,
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(resposeIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final error = respose?['Error'] ?? null;
        final data = respose?['Data'] ?? [];

        if (error != null) throw error;

        final list = data.map<ExpedicaoConferenciaItemModel>((json) {
          return ExpedicaoConferenciaItemModel.fromJson(json);
        }).toList();

        completer.complete(list);
      } catch (e) {
        completer.completeError(AppError(e.toString()));
        return completer.future;
      } finally {
        socket.off(resposeIn);
      }
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferenciaItemModel>> insert(
      ExpedicaoConferenciaItemModel entity) {
    final event = '${socket.id} conferencia.item.insert';
    final completer = Completer<List<ExpedicaoConferenciaItemModel>>();
    final resposeIn = uuid.v4();

    final send = SendMutationSocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      mutation: entity.toJson(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(resposeIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
          return ExpedicaoConferenciaItemModel.fromJson(json);
        }).toList();

        completer.complete(list);
      } catch (e) {
        completer.completeError(AppError(e.toString()));
        return completer.future;
      } finally {
        socket.off(resposeIn);
      }
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferenciaItemModel>> insertAll(
      List<ExpedicaoConferenciaItemModel> entity) {
    final event = '${socket.id} conferencia.item.insert';
    final completer = Completer<List<ExpedicaoConferenciaItemModel>>();
    final resposeIn = uuid.v4();

    final send = SendMutationsSocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      mutation: entity.map((el) => el.toJson()).toList(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(resposeIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
          return ExpedicaoConferenciaItemModel.fromJson(json);
        }).toList();

        completer.complete(list);
      } catch (e) {
        completer.completeError(AppError(e.toString()));
        return completer.future;
      } finally {
        socket.off(resposeIn);
      }
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferenciaItemModel>> update(
      ExpedicaoConferenciaItemModel entity) {
    final event = '${socket.id} conferencia.item.update';
    final completer = Completer<List<ExpedicaoConferenciaItemModel>>();
    final resposeIn = uuid.v4();

    final send = SendMutationSocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      mutation: entity.toJson(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(resposeIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
          return ExpedicaoConferenciaItemModel.fromJson(json);
        }).toList();

        completer.complete(list);
      } catch (e) {
        completer.completeError(AppError(e.toString()));
        return completer.future;
      } finally {
        socket.off(resposeIn);
      }
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferenciaItemModel>> updateAll(
      List<ExpedicaoConferenciaItemModel> entity) {
    final event = '${socket.id} conferencia.item.update';
    final completer = Completer<List<ExpedicaoConferenciaItemModel>>();
    final resposeIn = uuid.v4();

    final send = SendMutationsSocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      mutation: entity.map((el) => el.toJson()).toList(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(resposeIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;
        final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
          return ExpedicaoConferenciaItemModel.fromJson(json);
        }).toList();

        completer.complete(list);
      } catch (e) {
        completer.completeError(AppError(e.toString()));
        return completer.future;
      } finally {
        socket.off(resposeIn);
      }
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferenciaItemModel>> delete(
      ExpedicaoConferenciaItemModel entity) {
    final event = '${socket.id} conferencia.item.delete';
    final completer = Completer<List<ExpedicaoConferenciaItemModel>>();
    final resposeIn = uuid.v4();

    final send = SendMutationSocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      mutation: entity.toJson(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(resposeIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
          return ExpedicaoConferenciaItemModel.fromJson(json);
        }).toList();

        completer.complete(list);
      } catch (e) {
        completer.completeError(AppError(e.toString()));
        return completer.future;
      } finally {
        socket.off(resposeIn);
      }
    });

    return completer.future;
  }

  Future<List<ExpedicaoConferenciaItemModel>> deleteAll(
      List<ExpedicaoConferenciaItemModel> entity) {
    final event = '${socket.id} conferencia.item.delete';
    final completer = Completer<List<ExpedicaoConferenciaItemModel>>();
    final resposeIn = uuid.v4();

    final send = SendMutationsSocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      mutation: entity.map((el) => el.toJson()).toList(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(resposeIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
          return ExpedicaoConferenciaItemModel.fromJson(json);
        }).toList();

        completer.complete(list);
      } catch (e) {
        completer.completeError(AppError(e.toString()));
        return completer.future;
      } finally {
        socket.off(resposeIn);
      }
    });

    return completer.future;
  }
}
