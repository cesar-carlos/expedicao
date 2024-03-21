import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_model.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class CarrinhoPercursoEstagioRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoCarrinhoPercursoEstagioModel>> select(
      [String params = '']) {
    final event = '${socket.id} carrinho.percurso.estagio.select';
    final completer = Completer<List<ExpedicaoCarrinhoPercursoEstagioModel>>();
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

        if (data.isEmpty) {
          completer.complete([]);
          return;
        }

        final list = data.map<ExpedicaoCarrinhoPercursoEstagioModel>((json) {
          return ExpedicaoCarrinhoPercursoEstagioModel.fromJson(json);
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

  Future<List<ExpedicaoCarrinhoPercursoEstagioModel>> insert(
      ExpedicaoCarrinhoPercursoEstagioModel entity) {
    final event = '${socket.id} carrinho.percurso.estagio.insert';
    final completer = Completer<List<ExpedicaoCarrinhoPercursoEstagioModel>>();
    final resposeIn = uuid.v4();

    final send = SendMutationSocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      mutation: entity.toJson(),
    );

    try {
      socket.emit(event, jsonEncode(send.toJson()));
      socket.on(resposeIn, (receiver) async {
        final data = jsonDecode(receiver);
        final mutation = data?['mutation'] ?? [];
        final error = data?['error'] ?? null;
        socket.off(resposeIn);

        if (error != null) {
          completer.completeError(AppError(error));
          return;
        }

        final list =
            mutation.map<ExpedicaoCarrinhoPercursoEstagioModel>((json) {
          return ExpedicaoCarrinhoPercursoEstagioModel.fromJson(json);
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

  Future<List<ExpedicaoCarrinhoPercursoEstagioModel>> update(
      ExpedicaoCarrinhoPercursoEstagioModel entity) {
    final event = '${socket.id} carrinho.percurso.estagio.update';
    final completer = Completer<List<ExpedicaoCarrinhoPercursoEstagioModel>>();
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

        if (error != null) {
          completer.completeError(AppError(error));
          return;
        }

        final list =
            mutation.map<ExpedicaoCarrinhoPercursoEstagioModel>((json) {
          return ExpedicaoCarrinhoPercursoEstagioModel.fromJson(json);
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

  Future<List<ExpedicaoCarrinhoPercursoEstagioModel>> delete(
      ExpedicaoCarrinhoPercursoEstagioModel entity) {
    final event = '${socket.id} carrinho.percurso.estagio.delete';
    final completer = Completer<List<ExpedicaoCarrinhoPercursoEstagioModel>>();
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
          completer.completeError(AppError(error));
          return;
        }

        final list =
            mutation.map<ExpedicaoCarrinhoPercursoEstagioModel>((json) {
          return ExpedicaoCarrinhoPercursoEstagioModel.fromJson(json);
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
}
