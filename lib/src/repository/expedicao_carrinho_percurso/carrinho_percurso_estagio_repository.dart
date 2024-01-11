import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_error_code.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_model.dart';

class CarrinhoPercursoEstagioRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoPercursoEstagioModel>> select([String params = '']) {
    if (socket.connected == false) {
      throw AppError(
        AppErrorCode.socketDesconected,
        'Socket não conectado',
      );
    }

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

  Future<List<ExpedicaoPercursoEstagioModel>> insert(
      ExpedicaoPercursoEstagioModel entity) {
    if (socket.connected == false) {
      throw AppError(
        AppErrorCode.socketDesconected,
        'Socket não conectado',
      );
    }

    final event = '${socket.id} carrinho.percurso.estagio.insert';
    final completer = Completer<List<ExpedicaoPercursoEstagioModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": entity.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) async {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ExpedicaoPercursoEstagioModel>((json) {
        return ExpedicaoPercursoEstagioModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoPercursoEstagioModel>> update(
      ExpedicaoPercursoEstagioModel entity) {
    if (socket.connected == false) {
      throw AppError(
        AppErrorCode.socketDesconected,
        'Socket não conectado',
      );
    }

    final event = '${socket.id} carrinho.percurso.estagio.update';
    final completer = Completer<List<ExpedicaoPercursoEstagioModel>>();
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

      final list = mutation.map<ExpedicaoPercursoEstagioModel>((json) {
        return ExpedicaoPercursoEstagioModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoPercursoEstagioModel>> delete(
      ExpedicaoPercursoEstagioModel entity) {
    if (socket.connected == false) {
      throw AppError(
        AppErrorCode.socketDesconected,
        'Socket não conectado',
      );
    }

    final event = '${socket.id} carrinho.percurso.estagio.delete';
    final completer = Completer<List<ExpedicaoPercursoEstagioModel>>();
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

      final list = mutation.map<ExpedicaoPercursoEstagioModel>((json) {
        return ExpedicaoPercursoEstagioModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }
}
