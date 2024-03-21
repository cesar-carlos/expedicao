import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/send_mutations_socket_model.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class SepararItemRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoSepararItemModel>> select([String params = '']) {
    final event = '${socket.id} separar.item.select';
    final completer = Completer<List<ExpedicaoSepararItemModel>>();
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

        final list = data.map<ExpedicaoSepararItemModel>((json) {
          return ExpedicaoSepararItemModel.fromJson(json);
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

  Future<List<ExpedicaoSepararItemModel>> insert(
      ExpedicaoSepararItemModel entity) {
    final event = '${socket.id} separar.item.insert';
    final completer = Completer<List<ExpedicaoSepararItemModel>>();
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

        final list = mutation.map<ExpedicaoSepararItemModel>((json) {
          return ExpedicaoSepararItemModel.fromJson(json);
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

  Future<List<ExpedicaoSepararItemModel>> insertAll(
      List<ExpedicaoSepararItemModel> entitys) {
    final event = '${socket.id} separar.item.insert';
    final completer = Completer<List<ExpedicaoSepararItemModel>>();
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

        final list = mutation.map<ExpedicaoSepararItemModel>((json) {
          return ExpedicaoSepararItemModel.fromJson(json);
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

  Future<List<ExpedicaoSepararItemModel>> update(
      ExpedicaoSepararItemModel entity) {
    final event = '${socket.id} separar.item.update';
    final completer = Completer<List<ExpedicaoSepararItemModel>>();
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

        final list = mutation.map<ExpedicaoSepararItemModel>((json) {
          return ExpedicaoSepararItemModel.fromJson(json);
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

  Future<List<ExpedicaoSepararItemModel>> updateAll(
      List<ExpedicaoSepararItemModel> entitys) {
    final event = '${socket.id} separar.item.update';
    final completer = Completer<List<ExpedicaoSepararItemModel>>();
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

        final list = mutation.map<ExpedicaoSepararItemModel>((json) {
          return ExpedicaoSepararItemModel.fromJson(json);
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

  Future<List<ExpedicaoSepararItemModel>> delete(
      ExpedicaoSepararItemModel entity) {
    final event = '${socket.id} separar.item.delete';
    final completer = Completer<List<ExpedicaoSepararItemModel>>();
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

        final list = mutation.map<ExpedicaoSepararItemModel>((json) {
          return ExpedicaoSepararItemModel.fromJson(json);
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

  Future<List<ExpedicaoSepararItemModel>> deleteAll(
      List<ExpedicaoSepararItemModel> entitys) {
    final event = '${socket.id} separar.item.delete';
    final completer = Completer<List<ExpedicaoSepararItemModel>>();
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

        final list = mutation.map<ExpedicaoSepararItemModel>((json) {
          return ExpedicaoSepararItemModel.fromJson(json);
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
