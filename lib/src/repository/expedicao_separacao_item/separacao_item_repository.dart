import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_socket.config.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';

class SeparacaoItemRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoSeparacaoItemModel>> select([String params = '']) {
    final event = '${socket.id} separacao.item.select';
    final completer = Completer<List<ExpedicaoSeparacaoItemModel>>();
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

      final list = data.map<ExpedicaoSeparacaoItemModel>((json) {
        return ExpedicaoSeparacaoItemModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<ExpedicaoSeparacaoItemModel> insert(
      ExpedicaoSeparacaoItemModel entity) {
    final event = '${socket.id} separacao.item.insert';
    final completer = Completer<ExpedicaoSeparacaoItemModel>();
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
      final carrinho = ExpedicaoSeparacaoItemModel.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(carrinho);
    });

    return completer.future;
  }

  Future<ExpedicaoSeparacaoItemModel> update(
      ExpedicaoSeparacaoItemModel entity) {
    final event = '${socket.id} separacao.item.update';
    final completer = Completer<ExpedicaoSeparacaoItemModel>();
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
      final carrinho = ExpedicaoSeparacaoItemModel.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(carrinho);
    });

    return completer.future;
  }

  Future<List<ExpedicaoSeparacaoItemModel>> updateAll(
      List<ExpedicaoSeparacaoItemModel> entity) {
    final event = '${socket.id} separacao.item.update';
    final completer = Completer<List<ExpedicaoSeparacaoItemModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "mutation": entity.map((el) => el.toJson()).toList(),
    };

    socket.emit(event, jsonEncode(send));
    socket.on(resposeIn, (receiver) {
      final data = jsonDecode(receiver);
      final mutation = data?['mutation'];
      final carrinho = mutation
          .map<ExpedicaoSeparacaoItemModel>(
              (json) => ExpedicaoSeparacaoItemModel.fromJson(json))
          .toList();
      socket.off(resposeIn);
      completer.complete(carrinho);
    });

    return completer.future;
  }

  Future<ExpedicaoSeparacaoItemModel> delete(
      ExpedicaoSeparacaoItemModel entity) {
    final event = '${socket.id} separacao.item.delete';
    final completer = Completer<ExpedicaoSeparacaoItemModel>();
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
      final carrinho = ExpedicaoSeparacaoItemModel.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(carrinho);
    });

    return completer.future;
  }
}
