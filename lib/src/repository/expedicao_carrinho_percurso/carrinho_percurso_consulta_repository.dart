import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/app/app_socket.config.dart';

class CarrinhoPercursoConsultaRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoCarrinhoPercursoConsultaModel>> select(
      [String params = '']) {
    if (socket.connected == false) throw AppError('Socket não conectado');

    final event = '${socket.id} carrinho.percurso.consulta';
    final completer = Completer<List<ExpedicaoCarrinhoPercursoConsultaModel>>();
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
        return;
      }

      final list = data.map<ExpedicaoCarrinhoPercursoConsultaModel>((json) {
        return ExpedicaoCarrinhoPercursoConsultaModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }
}
