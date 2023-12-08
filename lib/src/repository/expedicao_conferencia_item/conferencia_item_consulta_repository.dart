import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_error_code.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_consulta_model.dart';
import 'package:app_expedicao/src/app/app_socket.config.dart';

class ConferenciaItemConsultaRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaConferenciaItemConsultaModel>> select([
    String params = '',
  ]) {
    if (socket.connected == false) {
      throw AppError(
        AppErrorCode.socketDesconected,
        'Socket não conectado',
      );
    }

    final event = '${socket.id} conferencia.item.consulta';
    final completer = Completer<List<ExpedicaConferenciaItemConsultaModel>>();
    final resposeIn = uuid.v4();

    final send = {
      "session": socket.id,
      "resposeIn": resposeIn,
      "where": params,
    };

    socket.emit(event, jsonEncode(send));
    socket.on(
      resposeIn,
      (receiver) {
        try {
          final data = jsonDecode(receiver);

          if (data.isEmpty) {
            completer.complete([]);
            return;
          }

          final list = data.map<ExpedicaConferenciaItemConsultaModel>((json) {
            return ExpedicaConferenciaItemConsultaModel.fromJson(json);
          }).toList();

          socket.off(resposeIn);
          completer.complete(list);
        } catch (e) {
          completer.complete([]);
        }
      },
    );

    return completer.future;
  }
}
