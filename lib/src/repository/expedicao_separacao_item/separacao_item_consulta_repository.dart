import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/app/app_socket.config.dart';

class SeparacaoItemConsultaRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaSeparacaoItemConsultaModel>> select([
    String params = '',
  ]) {
    final event = '${socket.id} separacao.item.consulta';
    final completer = Completer<List<ExpedicaSeparacaoItemConsultaModel>>();
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

          final list = data.map<ExpedicaSeparacaoItemConsultaModel>((json) {
            return ExpedicaSeparacaoItemConsultaModel.fromJson(json);
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
