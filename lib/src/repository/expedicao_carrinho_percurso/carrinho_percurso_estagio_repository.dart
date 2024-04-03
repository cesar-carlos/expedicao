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

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(resposeIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final error = respose?['Error'] ?? null;
        final data = respose?['Data'] ?? [];

        if (error != null) throw error;

        final list = data.map<ExpedicaoCarrinhoPercursoEstagioModel>((json) {
          return ExpedicaoCarrinhoPercursoEstagioModel.fromJson(json);
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

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(resposeIn, (receiver) async {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list =
            mutation.map<ExpedicaoCarrinhoPercursoEstagioModel>((json) {
          return ExpedicaoCarrinhoPercursoEstagioModel.fromJson(json);
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

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(resposeIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list =
            mutation.map<ExpedicaoCarrinhoPercursoEstagioModel>((json) {
          return ExpedicaoCarrinhoPercursoEstagioModel.fromJson(json);
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

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(resposeIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list =
            mutation.map<ExpedicaoCarrinhoPercursoEstagioModel>((json) {
          return ExpedicaoCarrinhoPercursoEstagioModel.fromJson(json);
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
