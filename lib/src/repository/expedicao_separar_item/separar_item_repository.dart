import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_socket.config.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_model.dart';

class SepararItemRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoSepararItemModel>> select([String params = '']) {
    final event = '${socket.id} separar.item.select';
    final completer = Completer<List<ExpedicaoSepararItemModel>>();
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

      final list = data.map<ExpedicaoSepararItemModel>((json) {
        return ExpedicaoSepararItemModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }

  Future<ExpedicaoSepararItemModel> insert(ExpedicaoSepararItemModel entity) {
    final event = '${socket.id} separar.item.insert';
    final completer = Completer<ExpedicaoSepararItemModel>();
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
      final carrinho = ExpedicaoSepararItemModel.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(carrinho);
    });

    return completer.future;
  }

  Future<ExpedicaoSepararItemModel> update(ExpedicaoSepararItemModel entity) {
    final event = '${socket.id} separar.item.update';
    final completer = Completer<ExpedicaoSepararItemModel>();
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
      final carrinho = ExpedicaoSepararItemModel.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(carrinho);
    });

    return completer.future;
  }

  Future<ExpedicaoSepararItemModel> delete(ExpedicaoSepararItemModel entity) {
    final event = '${socket.id} separar.item.delete';
    final completer = Completer<ExpedicaoSepararItemModel>();
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
      final carrinho = ExpedicaoSepararItemModel.fromJson(mutation);
      socket.off(resposeIn);
      completer.complete(carrinho);
    });

    return completer.future;
  }
}
