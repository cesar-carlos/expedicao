import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_error_code.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model%20copy.dart';
import 'package:app_expedicao/src/model/send_query_socket_model%20copy.dart';
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

    try {
      socket.emit(event, jsonEncode(send.toJson()));
      socket.on(resposeIn, (receiver) {
        final data = jsonDecode(receiver) as List<dynamic>;
        //final error = data?['error'] ?? null;
        socket.off(resposeIn);

        // if (error != null) {
        //   completer.completeError(AppError(AppErrorCode.separacao, error));
        //   return;
        // }

        if (data.isEmpty) {
          completer.complete([]);
          return;
        }

        final list = data.map<ExpedicaoConferenciaItemModel>((json) {
          return ExpedicaoConferenciaItemModel.fromJson(json);
        }).toList();

        completer.complete(list);
      });

      return completer.future;
    } catch (e) {
      socket.off(resposeIn);
      completer.completeError(AppError(AppErrorCode.separacao, e.toString()));
      return completer.future;
    }
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

    try {
      socket.emit(event, jsonEncode(send.toJson()));
      socket.on(resposeIn, (receiver) {
        final data = jsonDecode(receiver);
        final mutation = data?['mutation'] ?? [];
        final error = data?['error'] ?? null;
        socket.off(resposeIn);

        if (error != null) {
          completer.completeError(AppError(AppErrorCode.separacao, error));
          return;
        }

        final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
          return ExpedicaoConferenciaItemModel.fromJson(json);
        }).toList();

        completer.complete(list);
      });

      return completer.future;
    } catch (e) {
      socket.off(resposeIn);
      completer.completeError(AppError(AppErrorCode.separacao, e.toString()));
      return completer.future;
    }
  }

  Future<List<ExpedicaoConferenciaItemModel>> insertAll(
      List<ExpedicaoConferenciaItemModel> entity) {
    final event = '${socket.id} conferencia.item.insert';
    final completer = Completer<List<ExpedicaoConferenciaItemModel>>();
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
          completer.completeError(AppError(AppErrorCode.separacao, error));
          return;
        }

        final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
          return ExpedicaoConferenciaItemModel.fromJson(json);
        }).toList();

        completer.complete(list);
      });

      return completer.future;
    } catch (e) {
      socket.off(resposeIn);
      completer.completeError(AppError(AppErrorCode.separacao, e.toString()));
      return completer.future;
    }
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

    try {
      socket.emit(event, jsonEncode(send.toJson()));
      socket.on(resposeIn, (receiver) {
        final data = jsonDecode(receiver);
        final mutation = data?['mutation'] ?? [];
        final error = data?['error'] ?? null;
        socket.off(resposeIn);

        if (error != null) {
          completer.completeError(AppError(AppErrorCode.separacao, error));
          return;
        }

        final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
          return ExpedicaoConferenciaItemModel.fromJson(json);
        }).toList();

        completer.complete(list);
      });

      return completer.future;
    } catch (e) {
      socket.off(resposeIn);
      completer.completeError(AppError(AppErrorCode.separacao, e.toString()));
      return completer.future;
    }
  }

  Future<List<ExpedicaoConferenciaItemModel>> updateAll(
      List<ExpedicaoConferenciaItemModel> entity) {
    final event = '${socket.id} conferencia.item.update';
    final completer = Completer<List<ExpedicaoConferenciaItemModel>>();
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
          completer.completeError(AppError(AppErrorCode.separacao, error));
          return;
        }

        final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
          return ExpedicaoConferenciaItemModel.fromJson(json);
        }).toList();

        completer.complete(list);
      });

      return completer.future;
    } catch (e) {
      socket.off(resposeIn);
      completer.completeError(AppError(AppErrorCode.separacao, e.toString()));
      return completer.future;
    }
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

    try {
      socket.emit(event, jsonEncode(send.toJson()));
      socket.on(resposeIn, (receiver) {
        final data = jsonDecode(receiver);
        final mutation = data?['mutation'] ?? [];
        final error = data?['error'] ?? null;
        socket.off(resposeIn);

        if (error != null) {
          completer.completeError(AppError(AppErrorCode.separacao, error));
          return;
        }

        final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
          return ExpedicaoConferenciaItemModel.fromJson(json);
        }).toList();

        completer.complete(list);
      });

      return completer.future;
    } catch (e) {
      socket.off(resposeIn);
      completer.completeError(AppError(AppErrorCode.separacao, e.toString()));
      return completer.future;
    }
  }

  Future<List<ExpedicaoConferenciaItemModel>> deleteAll(
      List<ExpedicaoConferenciaItemModel> entity) {
    final event = '${socket.id} conferencia.item.delete';
    final completer = Completer<List<ExpedicaoConferenciaItemModel>>();
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
          completer.completeError(AppError(AppErrorCode.separacao, error));
          return;
        }

        final list = mutation.map<ExpedicaoConferenciaItemModel>((json) {
          return ExpedicaoConferenciaItemModel.fromJson(json);
        }).toList();

        completer.complete(list);
      });

      return completer.future;
    } catch (e) {
      socket.off(resposeIn);
      completer.completeError(AppError(AppErrorCode.separacao, e.toString()));
      return completer.future;
    }
  }
}
