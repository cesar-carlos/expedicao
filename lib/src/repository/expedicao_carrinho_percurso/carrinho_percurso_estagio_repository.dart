import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_socket.config.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_model.dart';

class CarrinhoPercursoEstagioRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoPercursoEstagioModel>> select([String params = '']) {
    final event = '${socket.id} carrinho.percurso.estagio.select';
    final completer = Completer<List<ExpedicaoPercursoEstagioModel>>();
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

      final list = data.map<ExpedicaoPercursoEstagioModel>((json) {
        return ExpedicaoPercursoEstagioModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<ExpedicaoPercursoEstagioModel> insert(
      ExpedicaoPercursoEstagioModel entity) {
    final event = '${socket.id} carrinho.percurso.estagio.insert';
    final completer = Completer<ExpedicaoPercursoEstagioModel>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": entity.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) async {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'];
      final carrinho = ExpedicaoPercursoEstagioModel.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(carrinho);
    });

    return completer.future;
  }

  Future<ExpedicaoPercursoEstagioModel> update(
      ExpedicaoPercursoEstagioModel entity) {
    final event = '${socket.id} carrinho.percurso.estagio.update';
    final completer = Completer<ExpedicaoPercursoEstagioModel>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": entity.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'];
      final carrinho = ExpedicaoPercursoEstagioModel.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(carrinho);
    });

    return completer.future;
  }

  Future<ExpedicaoPercursoEstagioModel> delete(
      ExpedicaoPercursoEstagioModel entity) {
    final event = '${socket.id} carrinho.percurso.estagio.delete';
    final completer = Completer<ExpedicaoPercursoEstagioModel>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": entity.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'];
      final carrinho = ExpedicaoPercursoEstagioModel.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(carrinho);
    });

    return completer.future;
  }
}
