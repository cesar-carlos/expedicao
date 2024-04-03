import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/send_mutations_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_model.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class ConferirItemRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoConferirItemModel>> select([String params = '']) {
    final event = '${socket.id} conferir.item.select';
    final completer = Completer<List<ExpedicaoConferirItemModel>>();
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

        final list = data.map<ExpedicaoConferirItemModel>((json) {
          return ExpedicaoConferirItemModel.fromJson(json);
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

  Future<List<ExpedicaoConferirItemModel>> insert(
      ExpedicaoConferirItemModel entity) {
    final event = '${socket.id} conferir.item.insert';
    final completer = Completer<List<ExpedicaoConferirItemModel>>();
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

        final list = mutation.map<ExpedicaoConferirItemModel>((json) {
          return ExpedicaoConferirItemModel.fromJson(json);
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

  Future<List<ExpedicaoConferirItemModel>> insertAll(
      List<ExpedicaoConferirItemModel> entitys) {
    final event = '${socket.id} conferir.item.insert';
    final completer = Completer<List<ExpedicaoConferirItemModel>>();
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

        final list = mutation.map<ExpedicaoConferirItemModel>((json) {
          return ExpedicaoConferirItemModel.fromJson(json);
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

  Future<List<ExpedicaoConferirItemModel>> update(
      ExpedicaoConferirItemModel entity) {
    final event = '${socket.id} conferir.item.update';
    final completer = Completer<List<ExpedicaoConferirItemModel>>();
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

        final list = mutation.map<ExpedicaoConferirItemModel>((json) {
          return ExpedicaoConferirItemModel.fromJson(json);
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

  Future<List<ExpedicaoConferirItemModel>> updateAll(
      List<ExpedicaoConferirItemModel> entitys) {
    final event = '${socket.id} conferir.item.update';
    final completer = Completer<List<ExpedicaoConferirItemModel>>();
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

        final list = mutation.map<ExpedicaoConferirItemModel>((json) {
          return ExpedicaoConferirItemModel.fromJson(json);
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

  Future<List<ExpedicaoConferirItemModel>> delete(
      ExpedicaoConferirItemModel entity) {
    final event = '${socket.id} conferir.item.delete';
    final completer = Completer<List<ExpedicaoConferirItemModel>>();
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

        final list = mutation.map<ExpedicaoConferirItemModel>((json) {
          return ExpedicaoConferirItemModel.fromJson(json);
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

  Future<List<ExpedicaoConferirItemModel>> deleteAll(
      List<ExpedicaoConferirItemModel> entitys) {
    final event = '${socket.id} conferir.item.delete';
    final completer = Completer<List<ExpedicaoConferirItemModel>>();
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

        final list = mutation.map<ExpedicaoConferirItemModel>((json) {
          return ExpedicaoConferirItemModel.fromJson(json);
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
