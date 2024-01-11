import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error_code.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_separacao_consulta_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class ConferirItemConsultaSeparacaoRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoConferirItemSeparacaoConsultaModel>> select(
      [String params = '']) {
    if (socket.connected == false) {
      throw AppError(
        AppErrorCode.socketDesconected,
        'Socket não conectado',
      );
    }

    final event = '${socket.id} conferir.separacao.item.consulta';
    final completer =
        Completer<List<ExpedicaoConferirItemSeparacaoConsultaModel>>();
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
          data.map<ExpedicaoConferirItemSeparacaoConsultaModel>((json) {
        return ExpedicaoConferirItemSeparacaoConsultaModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }
}
