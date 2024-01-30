import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_error_code.dart';
import 'package:app_expedicao/src/model/estoque_produto_conversao_unidade_consulta_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class EstoqueProdutoConversaoUnidadeConsultaRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<EstoqueProdutoConversaoUnidadeConsultaModel>> select(
      [String params = '']) {
    if (socket.connected == false) {
      throw AppError(
        AppErrorCode.socketDesconected,
        'Socket não conectado',
      );
    }

    final event = '${socket.id} estoque.produto.conversao.unidade.consulta';
    final completer =
        Completer<List<EstoqueProdutoConversaoUnidadeConsultaModel>>();
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

      final list =
          data.map<EstoqueProdutoConversaoUnidadeConsultaModel>((json) {
        return EstoqueProdutoConversaoUnidadeConsultaModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }
}