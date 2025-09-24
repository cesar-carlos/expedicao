import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/model/send_mutation_socket_model.dart';
import 'package:app_expedicao/src/model/expedicao_estagio_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class ExpedicaoEstagioRepository {
  final uuid = const Uuid();
  var socket = Get.find<AppSocketConfig>().socket;

  Future<List<ExpedicaoEstagioModel>> select(QueryBuilder queryBuilder) {
    final event = '${socket.id} expedicao.percurso.estagio.select';
    final completer = Completer<List<ExpedicaoEstagioModel>>();
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

        final list = data.map<ExpedicaoEstagioModel>((json) {
          return ExpedicaoEstagioModel.fromJson(json);
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

  Future<List<ExpedicaoEstagioModel>> insert(ExpedicaoEstagioModel entity) {
    final event = '${socket.id} expedicao.percurso.estagio.insert';
    final completer = Completer<List<ExpedicaoEstagioModel>>();
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
        final list = mutation.map<ExpedicaoEstagioModel>((json) {
          return ExpedicaoEstagioModel.fromJson(json);
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

  Future<List<ExpedicaoEstagioModel>> update(ExpedicaoEstagioModel entity) {
    final event = '${socket.id} expedicao.percurso.estagio.update';
    final completer = Completer<List<ExpedicaoEstagioModel>>();
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

        final list = mutation.map<ExpedicaoEstagioModel>((json) {
          return ExpedicaoEstagioModel.fromJson(json);
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

  Future<List<ExpedicaoEstagioModel>> delete(ExpedicaoEstagioModel entity) {
    final event = '${socket.id} expedicao.percurso.estagio.delete';
    final completer = Completer<List<ExpedicaoEstagioModel>>();
    final responseIn = uuid.v4();

    final send = SendMutationSocketModel(
      session: socket.id!,
      responseIn: responseIn,
      mutation: entity.toJson(),
    );

    socket.emit(event, jsonEncode(send..toJson()));
    socket.on(responseIn, (receiver) {
      try {
        final respose = jsonDecode(receiver);
        final mutation = respose?['Mutation'] ?? [];
        final error = respose?['Error'] ?? null;

        if (error != null) throw error;

        final list = mutation.map<ExpedicaoEstagioModel>((json) {
          return ExpedicaoEstagioModel.fromJson(json);
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
