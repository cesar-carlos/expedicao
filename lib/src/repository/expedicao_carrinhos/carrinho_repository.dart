import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/app/app_socket.config.dart';

class CarrinhoRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoCarrinhoModel>> select([String params = '']) {
    if (socket.connected == false) throw AppError('Socket não conectado');

    final event = '${socket.id} carrinho.select';
    final completer = Completer<List<ExpedicaoCarrinhoModel>>();
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

      final list = data.map<ExpedicaoCarrinhoModel>((json) {
        return ExpedicaoCarrinhoModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoCarrinhoModel>> insert(ExpedicaoCarrinhoModel carrinho) {
    if (socket.connected == false) throw AppError('Socket não conectado');

    final event = '${socket.id} carrinho.insert';
    final completer = Completer<List<ExpedicaoCarrinhoModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": carrinho.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ExpedicaoCarrinhoModel>((json) {
        return ExpedicaoCarrinhoModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoCarrinhoModel>> update(ExpedicaoCarrinhoModel carrinho) {
    if (socket.connected == false) throw AppError('Socket não conectado');

    final event = '${socket.id} carrinho.update';
    final completer = Completer<List<ExpedicaoCarrinhoModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": carrinho.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ExpedicaoCarrinhoModel>((json) {
        return ExpedicaoCarrinhoModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<List<ExpedicaoCarrinhoModel>> delete(ExpedicaoCarrinhoModel carrinho) {
    if (socket.connected == false) throw AppError('Socket não conectado');

    final event = '${socket.id} carrinho.delete';
    final completer = Completer<List<ExpedicaoCarrinhoModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": carrinho.toJson(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'] ?? [];

      final list = mutation.map<ExpedicaoCarrinhoModel>((json) {
        return ExpedicaoCarrinhoModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }
}
