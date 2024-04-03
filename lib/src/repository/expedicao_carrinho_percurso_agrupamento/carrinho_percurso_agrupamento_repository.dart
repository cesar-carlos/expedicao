import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_model.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class CarrinhoPercursoAgrupamentoRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoModel>> select(
      [String params = '']) {
    final event = '${socket.id} carrinho.percurso.agrupamento.select';
    final completer =
        Completer<List<ExpedicaoCarrinhoPercursoAgrupamentoModel>>();
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

        final list =
            data.map<ExpedicaoCarrinhoPercursoAgrupamentoModel>((json) {
          return ExpedicaoCarrinhoPercursoAgrupamentoModel.fromJson(json);
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

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoModel>> insert(
      ExpedicaoCarrinhoPercursoAgrupamentoModel entity) {
    final event = '${socket.id} carrinho.percurso.agrupamento.insert';
    final completer =
        Completer<List<ExpedicaoCarrinhoPercursoAgrupamentoModel>>();
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
            mutation.map<ExpedicaoCarrinhoPercursoAgrupamentoModel>((json) {
          return ExpedicaoCarrinhoPercursoAgrupamentoModel.fromJson(json);
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

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoModel>> update(
      ExpedicaoCarrinhoPercursoAgrupamentoModel entity) {
    final event = '${socket.id} carrinho.percurso.agrupamento.update';
    final completer =
        Completer<List<ExpedicaoCarrinhoPercursoAgrupamentoModel>>();
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
            mutation.map<ExpedicaoCarrinhoPercursoAgrupamentoModel>((json) {
          return ExpedicaoCarrinhoPercursoAgrupamentoModel.fromJson(json);
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

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoModel>> delete(
      ExpedicaoCarrinhoPercursoAgrupamentoModel entity) {
    final event = '${socket.id} carrinho.percurso.agrupamento.delete';
    final completer =
        Completer<List<ExpedicaoCarrinhoPercursoAgrupamentoModel>>();
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
            mutation.map<ExpedicaoCarrinhoPercursoAgrupamentoModel>((json) {
          return ExpedicaoCarrinhoPercursoAgrupamentoModel.fromJson(json);
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
