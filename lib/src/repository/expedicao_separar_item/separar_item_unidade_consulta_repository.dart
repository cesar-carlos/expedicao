import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_unidade_medida_consulta_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class SepararItemUnidadeMedidaConsultaRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoSepararItemUnidadeMedidaConsultaModel>> select(
      [String params = '']) {
    final event = '${socket.id} separar.item.unidade.medida.consulta';
    final completer =
        Completer<List<ExpedicaoSepararItemUnidadeMedidaConsultaModel>>();
    final resposeIn = uuid.v4();

    final send = SendQuerySocketModel(
      session: socket.id!,
      resposeIn: resposeIn,
      where: params,
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(resposeIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final error = respose?['Error'] ?? null;
        final data = respose?['Data'] ?? [];

        if (error != null) throw error;

        final list =
            data.map<ExpedicaoSepararItemUnidadeMedidaConsultaModel>((json) {
          return ExpedicaoSepararItemUnidadeMedidaConsultaModel.fromJson(json);
        }).toList();

        completer.complete(list);
      } catch (e) {
        completer.completeError(AppError(e.toString()));
        return completer.future;
      } finally {
        socket.off(resposeIn);
      }
    });

    return completer.future;
  }
}
