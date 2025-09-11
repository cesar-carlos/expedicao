import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_tipo_operacao_armazenagem.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class TipoOperacaoArmazenagemRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoTipoOperacaoArmazenagem>> select([String params = '']) {
    final event = '${socket.id} tipo.operacao.armazenagem.select';
    final completer = Completer<List<ExpedicaoTipoOperacaoArmazenagem>>();
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

        final list = data.map<ExpedicaoTipoOperacaoArmazenagem>((json) {
          return ExpedicaoTipoOperacaoArmazenagem.fromJson(json);
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

  Future<List<ExpedicaoTipoOperacaoArmazenagem>> insert(
      ExpedicaoTipoOperacaoArmazenagem entity) {
    final event = '${socket.id} tipo.operacao.armazenagem.insert';
    final completer = Completer<List<ExpedicaoTipoOperacaoArmazenagem>>();
    final responseIn = uuid.v4();

    final send = SendMutationSocketModel(
      session: socket.id!,
      responseIn: responseIn,
      mutation: entity.toJson(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(responseIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoTipoOperacaoArmazenagem>((json) {
          return ExpedicaoTipoOperacaoArmazenagem.fromJson(json);
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

  Future<List<ExpedicaoTipoOperacaoArmazenagem>> update(
      ExpedicaoTipoOperacaoArmazenagem entity) {
    final event = '${socket.id} tipo.operacao.armazenagem.update';
    final completer = Completer<List<ExpedicaoTipoOperacaoArmazenagem>>();
    final responseIn = uuid.v4();

    final send = SendMutationSocketModel(
      session: socket.id!,
      responseIn: responseIn,
      mutation: entity.toJson(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(responseIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoTipoOperacaoArmazenagem>((json) {
          return ExpedicaoTipoOperacaoArmazenagem.fromJson(json);
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

  Future<List<ExpedicaoTipoOperacaoArmazenagem>> delete(
      ExpedicaoTipoOperacaoArmazenagem entity) {
    final event = '${socket.id} tipo.operacao.armazenagem.delete';
    final completer = Completer<List<ExpedicaoTipoOperacaoArmazenagem>>();
    final responseIn = uuid.v4();

    final send = SendMutationSocketModel(
      session: socket.id!,
      responseIn: responseIn,
      mutation: entity.toJson(),
    );

    socket.emit(event, jsonEncode(send.toJson()));
    socket.on(responseIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoTipoOperacaoArmazenagem>((json) {
          return ExpedicaoTipoOperacaoArmazenagem.fromJson(json);
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
