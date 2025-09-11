import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/send_mutations_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';

class SeparacaoItemRepository {
  final uuid = const Uuid();
  final socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoSeparacaoItemModel>> select([String params = '']) {
    final event = '${socket.id} separacao.item.select';
    final completer = Completer<List<ExpedicaoSeparacaoItemModel>>();
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

        final list = data.map<ExpedicaoSeparacaoItemModel>((json) {
          return ExpedicaoSeparacaoItemModel.fromJson(json);
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

  Future<List<ExpedicaoSeparacaoItemModel>> insert(
      ExpedicaoSeparacaoItemModel entity) {
    final event = '${socket.id} separacao.item.insert';
    final completer = Completer<List<ExpedicaoSeparacaoItemModel>>();
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

        final list = mutation.map<ExpedicaoSeparacaoItemModel>((json) {
          return ExpedicaoSeparacaoItemModel.fromJson(json);
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

  Future<List<ExpedicaoSeparacaoItemModel>> insertAll(
      List<ExpedicaoSeparacaoItemModel> entitys) {
    final event = '${socket.id} separacao.item.insert';
    final completer = Completer<List<ExpedicaoSeparacaoItemModel>>();
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

        final list = mutation.map<ExpedicaoSeparacaoItemModel>((json) {
          return ExpedicaoSeparacaoItemModel.fromJson(json);
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

  Future<List<ExpedicaoSeparacaoItemModel>> update(
      ExpedicaoSeparacaoItemModel entity) {
    final event = '${socket.id} separacao.item.update';
    final completer = Completer<List<ExpedicaoSeparacaoItemModel>>();
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

        final list = mutation.map<ExpedicaoSeparacaoItemModel>((json) {
          return ExpedicaoSeparacaoItemModel.fromJson(json);
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

  Future<List<ExpedicaoSeparacaoItemModel>> updateAll(
      List<ExpedicaoSeparacaoItemModel> entity) {
    final event = '${socket.id} separacao.item.update';
    final completer = Completer<List<ExpedicaoSeparacaoItemModel>>();
    final responseIn = uuid.v4();

    final send = SendMutationsSocketModel(
      session: socket.id!,
      responseIn: responseIn,
      mutation: entity.map((el) => el.toJson()).toList(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(responseIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoSeparacaoItemModel>((json) {
          return ExpedicaoSeparacaoItemModel.fromJson(json);
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

  Future<List<ExpedicaoSeparacaoItemModel>> delete(
      ExpedicaoSeparacaoItemModel entity) {
    final event = '${socket.id} separacao.item.delete';
    final completer = Completer<List<ExpedicaoSeparacaoItemModel>>();
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

        final list = mutation.map<ExpedicaoSeparacaoItemModel>((json) {
          return ExpedicaoSeparacaoItemModel.fromJson(json);
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

  Future<List<ExpedicaoSeparacaoItemModel>> deleteAll(
      List<ExpedicaoSeparacaoItemModel> entity) {
    final event = '${socket.id} separacao.item.delete';
    final completer = Completer<List<ExpedicaoSeparacaoItemModel>>();
    final responseIn = uuid.v4();

    final send = SendMutationsSocketModel(
      session: socket.id!,
      responseIn: responseIn,
      mutation: entity.map((el) => el.toJson()).toList(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(responseIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoSeparacaoItemModel>((json) {
          return ExpedicaoSeparacaoItemModel.fromJson(json);
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
