import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/send_mutations_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_model.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class SepararItemRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoSepararItemModel>> select([String params = '']) {
    final event = '${socket.id} separar.item.select';
    final completer = Completer<List<ExpedicaoSepararItemModel>>();
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

        final list = data.map<ExpedicaoSepararItemModel>((json) {
          return ExpedicaoSepararItemModel.fromJson(json);
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

  Future<List<ExpedicaoSepararItemModel>> insert(
      ExpedicaoSepararItemModel entity) {
    final event = '${socket.id} separar.item.insert';
    final completer = Completer<List<ExpedicaoSepararItemModel>>();
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

        final list = mutation.map<ExpedicaoSepararItemModel>((json) {
          return ExpedicaoSepararItemModel.fromJson(json);
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

  Future<List<ExpedicaoSepararItemModel>> insertAll(
      List<ExpedicaoSepararItemModel> entitys) {
    final event = '${socket.id} separar.item.insert';
    final completer = Completer<List<ExpedicaoSepararItemModel>>();
    final responseIn = uuid.v4();

    final send = SendMutationsSocketModel(
      session: socket.id!,
      responseIn: responseIn,
      mutation: entitys.map((el) => el.toJson()).toList(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(responseIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoSepararItemModel>((json) {
          return ExpedicaoSepararItemModel.fromJson(json);
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

  Future<List<ExpedicaoSepararItemModel>> update(
      ExpedicaoSepararItemModel entity) {
    final event = '${socket.id} separar.item.update';
    final completer = Completer<List<ExpedicaoSepararItemModel>>();
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

        final list = mutation.map<ExpedicaoSepararItemModel>((json) {
          return ExpedicaoSepararItemModel.fromJson(json);
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

  Future<List<ExpedicaoSepararItemModel>> updateAll(
      List<ExpedicaoSepararItemModel> entitys) {
    final event = '${socket.id} separar.item.update';
    final completer = Completer<List<ExpedicaoSepararItemModel>>();
    final responseIn = uuid.v4();

    final send = SendMutationsSocketModel(
      session: socket.id!,
      responseIn: responseIn,
      mutation: entitys.map((el) => el.toJson()).toList(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(responseIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoSepararItemModel>((json) {
          return ExpedicaoSepararItemModel.fromJson(json);
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

  Future<List<ExpedicaoSepararItemModel>> delete(
      ExpedicaoSepararItemModel entity) {
    final event = '${socket.id} separar.item.delete';
    final completer = Completer<List<ExpedicaoSepararItemModel>>();
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

        final list = mutation.map<ExpedicaoSepararItemModel>((json) {
          return ExpedicaoSepararItemModel.fromJson(json);
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

  Future<List<ExpedicaoSepararItemModel>> deleteAll(
      List<ExpedicaoSepararItemModel> entitys) {
    final event = '${socket.id} separar.item.delete';
    final completer = Completer<List<ExpedicaoSepararItemModel>>();
    final responseIn = uuid.v4();

    final send = SendMutationsSocketModel(
      session: socket.id!,
      responseIn: responseIn,
      mutation: entitys.map((el) => el.toJson()).toList(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(responseIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoSepararItemModel>((json) {
          return ExpedicaoSepararItemModel.fromJson(json);
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
