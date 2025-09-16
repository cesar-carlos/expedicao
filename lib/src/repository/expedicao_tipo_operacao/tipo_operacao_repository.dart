import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_tipo_operacao_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class TipoOperacaoRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoTipoOperacaoModel>> select(QueryBuilder queryBuilder) {
    final event = '${socket.id} tipo.operacao.expedicao.select';
    final completer = Completer<List<ExpedicaoTipoOperacaoModel>>();
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

        final list = data.map<ExpedicaoTipoOperacaoModel>((json) {
          return ExpedicaoTipoOperacaoModel.fromJson(json);
        }).toList();

        completer.complete(list);
      } catch (error) {
        completer.completeError(AppError(
          error.toString(),
          details: '''Erro ao buscar tipo de operação''',
        ));

        return completer.future;
      } finally {
        socket.off(responseIn);
      }
    });

    return completer.future;
  }

  Future<List<ExpedicaoTipoOperacaoModel>> insert(
      ExpedicaoTipoOperacaoModel entity) {
    final event = '${socket.id} tipo.operacao.expedicao.insert';
    final completer = Completer<List<ExpedicaoTipoOperacaoModel>>();
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

        final list = mutation.map<ExpedicaoTipoOperacaoModel>((json) {
          return ExpedicaoTipoOperacaoModel.fromJson(json);
        }).toList();

        completer.complete(list);
      } catch (error) {
        completer.completeError(AppError(
          error.toString(),
          details: '''Erro ao inserir tipo de operação''',
        ));

        return completer.future;
      } finally {
        socket.off(responseIn);
      }
    });

    return completer.future;
  }

  Future<List<ExpedicaoTipoOperacaoModel>> update(
      ExpedicaoTipoOperacaoModel entity) {
    final event = '${socket.id} tipo.operacao.expedicao.update';
    final completer = Completer<List<ExpedicaoTipoOperacaoModel>>();
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

        final list = mutation.map<ExpedicaoTipoOperacaoModel>((json) {
          return ExpedicaoTipoOperacaoModel.fromJson(json);
        }).toList();

        completer.complete(list);
      } catch (error) {
        completer.completeError(AppError(
          error.toString(),
          details: '''Erro ao atualizar tipo de operação''',
        ));
        return completer.future;
      } finally {
        socket.off(responseIn);
      }
    });

    return completer.future;
  }

  Future<List<ExpedicaoTipoOperacaoModel>> delete(
      ExpedicaoTipoOperacaoModel entity) {
    final event = '${socket.id} tipo.operacao.expedicao.delete';
    final completer = Completer<List<ExpedicaoTipoOperacaoModel>>();
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

        final list = mutation.map<ExpedicaoTipoOperacaoModel>((json) {
          return ExpedicaoTipoOperacaoModel.fromJson(json);
        }).toList();

        completer.complete(list);
      } catch (error) {
        completer.completeError(AppError(
          error.toString(),
          details: '''Erro ao deletar tipo de operação''',
        ));
        return completer.future;
      } finally {
        socket.off(responseIn);
      }
    });

    return completer.future;
  }
}
