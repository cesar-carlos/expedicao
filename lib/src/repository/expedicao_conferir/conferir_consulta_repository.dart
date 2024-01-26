import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class ConferirConsultaRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoConferirConsultaModel>> select([String params = '']) {
    final event = '${socket.id} conferir.consulta';
    final completer = Completer<List<ExpedicaoConferirConsultaModel>>();
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

      final list = data.map<ExpedicaoConferirConsultaModel>((json) {
        return ExpedicaoConferirConsultaModel.fromJson(json);
      }).toList();

      socket.off(resposeIn);
      completer.complete(list);
    });

    return completer.future;
  }
}
