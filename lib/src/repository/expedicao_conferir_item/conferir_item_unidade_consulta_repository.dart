import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_unidade_medida_consulta_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class ConferirItemUnidadeMedidaConsultaRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoConferirItemUnidadeMedidaConsultaModel>> select(
      QueryBuilder queryBuilder) {
    final event = '${socket.id} conferir.item.unidade.medida.consulta';
    final completer =
        Completer<List<ExpedicaoConferirItemUnidadeMedidaConsultaModel>>();
    final responseIn = uuid.v4();

    final send = SendQuerySocketModel(
      session: socket.id!,
      responseIn: responseIn,
      where: queryBuilder.buildSqlWhere(),
      pagination: queryBuilder.buildPagination(),
      orderBy: queryBuilder.buildOrderByQuery(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(responseIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final error = respose?['Error'] ?? null;
        final data = respose?['Data'] ?? [];

        if (error != null) throw error;

        final list =
            data.map<ExpedicaoConferirItemUnidadeMedidaConsultaModel>((json) {
          return ExpedicaoConferirItemUnidadeMedidaConsultaModel.fromJson(json);
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
