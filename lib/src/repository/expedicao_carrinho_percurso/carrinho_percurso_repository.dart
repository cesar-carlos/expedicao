import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_socket.config.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';

class CarrinhoPercursoRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoCarrinhoPercursoModel>> select([String params = '']) {
    final event = '${socket.id} carrinho.percurso.select';
    final completer = Completer<List<ExpedicaoCarrinhoPercursoModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "where": params,
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);

      if (data.isEmpty) {
        completer.complete([]);
        socket.off(resposeIn);
        return;
      }

      final list = data.map<ExpedicaoCarrinhoPercursoModel>((json) {
        return ExpedicaoCarrinhoPercursoModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoCarrinhoPercursoModel>> insert(
      ExpedicaoCarrinhoPercursoModel entity) {
    final event = '${socket.id} carrinho.percurso.insert';
    final completer = Completer<List<ExpedicaoCarrinhoPercursoModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": entity.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ExpedicaoCarrinhoPercursoModel>((json) {
        return ExpedicaoCarrinhoPercursoModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoCarrinhoPercursoModel>> update(
      ExpedicaoCarrinhoPercursoModel entity) {
    final event = '${socket.id} carrinho.percurso.update';
    final completer = Completer<List<ExpedicaoCarrinhoPercursoModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": entity.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ExpedicaoCarrinhoPercursoModel>((json) {
        return ExpedicaoCarrinhoPercursoModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoCarrinhoPercursoModel>> delete(
      ExpedicaoCarrinhoPercursoModel entity) {
    final event = '${socket.id} carrinho.percurso.delete';
    final completer = Completer<List<ExpedicaoCarrinhoPercursoModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": entity.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ExpedicaoCarrinhoPercursoModel>((json) {
        return ExpedicaoCarrinhoPercursoModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }
}
