import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/send_mutations_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_armazenagem_item.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';

class ArmazenagemItemRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoArmazenagemItem>> select([String params = '']) {
    final event = '${socket.id} armazenagem.item.select';
    final completer = Completer<List<ExpedicaoArmazenagemItem>>();
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

        final list = data.map<ExpedicaoArmazenagemItem>((json) {
          return ExpedicaoArmazenagemItem.fromJson(json);
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

  Future<List<ExpedicaoArmazenagemItem>> insert(
      ExpedicaoArmazenagemItem entity) {
    final event = '${socket.id} armazenagem.item.insert';
    final completer = Completer<List<ExpedicaoArmazenagemItem>>();
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

        final list = mutation.map<ExpedicaoArmazenagemItem>((json) {
          return ExpedicaoArmazenagemItem.fromJson(json);
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

  Future<List<ExpedicaoArmazenagemItem>> insertAll(
      List<ExpedicaoArmazenagemItem> entitys) {
    final event = '${socket.id} armazenagem.item.insert';
    final completer = Completer<List<ExpedicaoArmazenagemItem>>();
    final resposeIn = uuid.v4();

    final send = SendMutationsSocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      mutations: entitys.map((el) => el.toJson()).toList(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(resposeIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;
        socket.off(resposeIn);

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoArmazenagemItem>((json) {
          return ExpedicaoArmazenagemItem.fromJson(json);
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

  Future<List<ExpedicaoArmazenagemItem>> update(
      ExpedicaoArmazenagemItem entity) {
    final event = '${socket.id} armazenagem.item.update';
    final completer = Completer<List<ExpedicaoArmazenagemItem>>();
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

        final list = mutation.map<ExpedicaoArmazenagemItem>((json) {
          return ExpedicaoArmazenagemItem.fromJson(json);
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

  Future<List<ExpedicaoArmazenagemItem>> updateAll(
      List<ExpedicaoArmazenagemItem> entitys) {
    final event = '${socket.id} armazenagem.item.update';
    final completer = Completer<List<ExpedicaoArmazenagemItem>>();
    final resposeIn = uuid.v4();

    final send = SendMutationsSocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      mutations: entitys.map((el) => el.toJson()).toList(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(resposeIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoArmazenagemItem>((json) {
          return ExpedicaoArmazenagemItem.fromJson(json);
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

  Future<List<ExpedicaoArmazenagemItem>> delete(
      ExpedicaoArmazenagemItem entity) {
    final event = '${socket.id} armazenagem.item.delete';
    final completer = Completer<List<ExpedicaoArmazenagemItem>>();
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

        final list = mutation.map<ExpedicaoArmazenagemItem>((json) {
          return ExpedicaoArmazenagemItem.fromJson(json);
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
