import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/model/estoque_produto_consulta_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class EstoqueProdutoConsultaRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<EstoqueProdutoConsultaModel>> select([String params = '']) {
    final event = '${socket.id} estoque.produto.consulta';
    final completer = Completer<List<EstoqueProdutoConsultaModel>>();
    final responseIn = uuid.v4();

    final send = SendQuerySocketModel(
      session: socket.id!,
      responseIn: responseIn,
      where: params,
    );

    try {
      socket.emit(event, jsonEncode(send.toJson()));
      socket.on(responseIn, (receiver) {
        final respose = jsonDecode(receiver);
        final error = respose?['Error'] ?? null;
        final data = respose?['Data'] ?? [];
        socket.off(responseIn);

        if (error != null) {
          completer.completeError(error);
          return;
        }

        final list = data.map<EstoqueProdutoConsultaModel>((json) {
          return EstoqueProdutoConsultaModel.fromJson(json);
        }).toList();

        completer.complete(list);
      });

      return completer.future;
    } catch (e) {
      socket.off(responseIn);
      completer.completeError(AppError(e.toString()));
      return completer.future;
    }
  }
}
