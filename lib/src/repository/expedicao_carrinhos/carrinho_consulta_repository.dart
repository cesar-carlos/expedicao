import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_error_code.dart';
import 'package:app_expedicao/src/model/send_query_socket_model%20copy.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_consulta_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class CarrinhoConsultaRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoCarrinhoConsultaModel>> select([String params = '']) {
    final event = '${socket.id} carrinho.consulta';
    final completer = Completer<List<ExpedicaoCarrinhoConsultaModel>>();
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
        //final error = data?['error'] ?? null;
        socket.off(resposeIn);

        // if (error != null) {
        //   completer.completeError(AppError(AppErrorCode.separacao, error));
        //   return;
        // }

        if (data.isEmpty) {
          completer.complete([]);
          return;
        }

        final list = data.map<ExpedicaoCarrinhoConsultaModel>((json) {
          return ExpedicaoCarrinhoConsultaModel.fromJson(json);
        }).toList();

        completer.complete(list);
      });

      return completer.future;
    } catch (e) {
      socket.off(resposeIn);
      completer.completeError(AppError(AppErrorCode.separacao, e.toString()));
      return completer.future;
    }
  }
}
