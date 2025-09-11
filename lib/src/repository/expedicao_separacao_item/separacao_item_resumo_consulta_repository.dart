import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_resumo.consulta_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class SeparacaoItemResumoConsultaRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaSeparacaoItemResumoConsultaModel>> select([
    String params = '',
  ]) {
    final event = '${socket.id} separacao.item.resumo.consulta';
    final completer =
        Completer<List<ExpedicaSeparacaoItemResumoConsultaModel>>();
    final responseIn = uuid.v4();

    final send = SendQuerySocketModel(
      session: socket.id!,
      responseIn: responseIn,
      where: params,
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(responseIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final error = respose?['Error'] ?? null;
        final data = respose?['Data'] ?? [];

        if (error != null) throw error;

        final list = data.map<ExpedicaSeparacaoItemResumoConsultaModel>((json) {
          return ExpedicaSeparacaoItemResumoConsultaModel.fromJson(json);
        }).toList();

        completer.complete(list);
      } catch (e) {
        completer.completeError(AppError(e.toString()));
        return completer.future;
      } finally {
        socket.off(responseIn);
      }
    });

    return completer.future;
  }
}
