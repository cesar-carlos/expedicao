import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/send_mutations_socket_model.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';

class SeparacaoItemRepository {
  final uuid = const Uuid();
  final socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoSeparacaoItemModel>> select([String params = '']) {
    final event = '${socket.id} separacao.item.select';
    final completer = Completer<List<ExpedicaoSeparacaoItemModel>>();
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

        final list = data.map<ExpedicaoSeparacaoItemModel>((json) {
          return ExpedicaoSeparacaoItemModel.fromJson(json);
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

  Future<List<ExpedicaoSeparacaoItemModel>> insert(
      ExpedicaoSeparacaoItemModel entity) {
    final event = '${socket.id} separacao.item.insert';
    final completer = Completer<List<ExpedicaoSeparacaoItemModel>>();
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

        final list = mutation.map<ExpedicaoSeparacaoItemModel>((json) {
          return ExpedicaoSeparacaoItemModel.fromJson(json);
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

  Future<List<ExpedicaoSeparacaoItemModel>> insertAll(
      List<ExpedicaoSeparacaoItemModel> entitys) {
    final event = '${socket.id} separacao.item.insert';
    final completer = Completer<List<ExpedicaoSeparacaoItemModel>>();
    final resposeIn = uuid.v4();

    final send = SendMutationsSocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      mutations: entitys.map((el) => el.toJson()).toList(),
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

        final list = mutation.map<ExpedicaoSeparacaoItemModel>((json) {
          return ExpedicaoSeparacaoItemModel.fromJson(json);
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

  Future<List<ExpedicaoSeparacaoItemModel>> update(
      ExpedicaoSeparacaoItemModel entity) {
    final event = '${socket.id} separacao.item.update';
    final completer = Completer<List<ExpedicaoSeparacaoItemModel>>();
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

        final list = mutation.map<ExpedicaoSeparacaoItemModel>((json) {
          return ExpedicaoSeparacaoItemModel.fromJson(json);
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

  Future<List<ExpedicaoSeparacaoItemModel>> updateAll(
      List<ExpedicaoSeparacaoItemModel> entity) {
    final event = '${socket.id} separacao.item.update';
    final completer = Completer<List<ExpedicaoSeparacaoItemModel>>();
    final resposeIn = uuid.v4();

    final send = SendMutationsSocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      mutations: entity.map((el) => el.toJson()).toList(),
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

        final list = mutation.map<ExpedicaoSeparacaoItemModel>((json) {
          return ExpedicaoSeparacaoItemModel.fromJson(json);
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

  Future<List<ExpedicaoSeparacaoItemModel>> delete(
      ExpedicaoSeparacaoItemModel entity) {
    final event = '${socket.id} separacao.item.delete';
    final completer = Completer<List<ExpedicaoSeparacaoItemModel>>();
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

        final list = mutation.map<ExpedicaoSeparacaoItemModel>((json) {
          return ExpedicaoSeparacaoItemModel.fromJson(json);
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

  Future<List<ExpedicaoSeparacaoItemModel>> deleteAll(
      List<ExpedicaoSeparacaoItemModel> entity) {
    final event = '${socket.id} separacao.item.delete';
    final completer = Completer<List<ExpedicaoSeparacaoItemModel>>();
    final resposeIn = uuid.v4();

    final send = SendMutationsSocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      mutations: entity.map((el) => el.toJson()).toList(),
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

        final list = mutation.map<ExpedicaoSeparacaoItemModel>((json) {
          return ExpedicaoSeparacaoItemModel.fromJson(json);
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
