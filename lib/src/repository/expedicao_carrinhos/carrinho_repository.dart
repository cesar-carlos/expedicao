import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/app/app_socket.config.dart';

class CarrinhoRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoCarrinhoModel>> select([String params = '']) {
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

  Future<void> insert(ExpedicaoCarrinhoModel carrinho) {
    final event = '${socket.id} carrinho.insert';
    final completer = Completer<ExpedicaoCarrinhoModel>();
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
      final carrinho = ExpedicaoCarrinhoModel.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(carrinho);
    });

    return completer.future;
  }

  Future<void> update(ExpedicaoCarrinhoModel carrinho) {
    final event = '${socket.id} carrinho.update';
    final completer = Completer<ExpedicaoCarrinhoModel>();
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
      final carrinho = ExpedicaoCarrinhoModel.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(carrinho);
    });

    return completer.future;
  }

  Future<void> delete(ExpedicaoCarrinhoModel carrinho) {
    final event = '${socket.id} carrinho.delete';
    final completer = Completer<ExpedicaoCarrinhoModel>();
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
      final carrinho = ExpedicaoCarrinhoModel.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(carrinho);
    });

    return completer.future;
  }
}