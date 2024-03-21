import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_consulta_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class CarrinhoPercursoAgrupamentoConsultaRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>> select(
      [String params = '']) {
    final event = '${socket.id} carrinho.percurso.agrupamento.consulta';
    final completer =
        Completer<List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>>();
    final resposeIn = uuid.v4();

    final send = SendQuerySocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      where: params,
    );

    try {
      socket.emit(event, jsonEncode(send.toJson()));
      socket.on(resposeIn, (receiver) {
        final data = jsonDecode(receiver) as List<dynamic>;
        socket.off(resposeIn);

        if (data.isEmpty) {
          completer.complete([]);
          return;
        }

        final list =
            data.map<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>((json) {
          return ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel.fromJson(
              json);
        }).toList();

        completer.complete(list);
      });

      return completer.future;
    } catch (e) {
      socket.off(resposeIn);
      completer.completeError(AppError(e.toString()));
      return completer.future;
    }
  }
}
