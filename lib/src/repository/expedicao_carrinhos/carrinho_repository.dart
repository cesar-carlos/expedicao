import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class CarrinhoRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoCarrinhoModel>> select([String params = '']) {
    final event = '${socket.id} carrinho.select';
    final completer = Completer<List<ExpedicaoCarrinhoModel>>();
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
          socket.off(resposeIn);
          return;
        }

        final list = data.map<ExpedicaoCarrinhoModel>((json) {
          return ExpedicaoCarrinhoModel.fromJson(json);
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

  Future<List<ExpedicaoCarrinhoModel>> insert(ExpedicaoCarrinhoModel entity) {
    final event = '${socket.id} carrinho.insert';
    final completer = Completer<List<ExpedicaoCarrinhoModel>>();
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

        final list = mutation.map<ExpedicaoCarrinhoModel>((json) {
          return ExpedicaoCarrinhoModel.fromJson(json);
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

  Future<List<ExpedicaoCarrinhoModel>> update(ExpedicaoCarrinhoModel entity) {
    final event = '${socket.id} carrinho.update';
    final completer = Completer<List<ExpedicaoCarrinhoModel>>();
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

        final list = mutation.map<ExpedicaoCarrinhoModel>((json) {
          return ExpedicaoCarrinhoModel.fromJson(json);
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

  Future<List<ExpedicaoCarrinhoModel>> delete(ExpedicaoCarrinhoModel entity) {
    final event = '${socket.id} carrinho.delete';
    final completer = Completer<List<ExpedicaoCarrinhoModel>>();
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

        final list = mutation.map<ExpedicaoCarrinhoModel>((json) {
          return ExpedicaoCarrinhoModel.fromJson(json);
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
