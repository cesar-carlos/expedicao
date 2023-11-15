import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/expedicao_percurso_estagio.dart';
import 'package:app_expedicao/src/app/app_socket.config.dart';

class PercursoEstagioRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoPercursoEstagio>> select([String params = '']) {
    final event = '${socket.id} percurso.estagio.select';
    final completer = Completer<List<ExpedicaoPercursoEstagio>>();
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

      final list = data.map<ExpedicaoPercursoEstagio>((json) {
        return ExpedicaoPercursoEstagio.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<void> insert(ExpedicaoPercursoEstagio carrinho) {
    final event = '${socket.id} percurso.estagio.insert';
    final completer = Completer<ExpedicaoPercursoEstagio>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": carrinho.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'];
      final carrinho = ExpedicaoPercursoEstagio.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(carrinho);
    });

    return completer.future;
  }

  Future<void> update(ExpedicaoPercursoEstagio carrinho) {
    final event = '${socket.id} percurso.estagio.update';
    final completer = Completer<ExpedicaoPercursoEstagio>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": carrinho.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'];
      final carrinho = ExpedicaoPercursoEstagio.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(carrinho);
    });

    return completer.future;
  }

  Future<void> delete(ExpedicaoPercursoEstagio carrinho) {
    final event = '${socket.id} percurso.estagio.delete';
    final completer = Completer<ExpedicaoPercursoEstagio>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": carrinho.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'];
      final carrinho = ExpedicaoPercursoEstagio.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(carrinho);
    });

    return completer.future;
  }
}
