import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Log dos canais `*.listen` usados na situação da separação e dos carrinhos.
abstract class AppSocketListenLog {
  static const tag = 'SOCKET-LISTEN';

  static bool isSituacaoChannel(String channel) {
    return channel.contains('separar.update') ||
        channel.contains('conferir.update') ||
        channel.contains('carrinho.percurso.estagio');
  }

  /// Envelope `Session` **ou** `SessionId` da linha (item de separação/conferência).
  static bool isOwnSession({
    required String? envelopeSession,
    required String? socketId,
    String? rowSessionId,
  }) {
    if (socketId == null || socketId.isEmpty) {
      return false;
    }
    if (envelopeSession != null &&
        envelopeSession.isNotEmpty &&
        envelopeSession == socketId) {
      return true;
    }
    if (rowSessionId != null &&
        rowSessionId.isNotEmpty &&
        rowSessionId == socketId) {
      return true;
    }
    return false;
  }

  static bool isListenLogChannel(String channel) {
    return isSituacaoChannel(channel) ||
        channel.contains('separacao.item') ||
        channel.contains('conferencia.item') ||
        channel.contains('separar.item.consulta.update') ||
        channel.contains('conferir.item.update');
  }

  static void received(String channel, dynamic data) {
    if (!isListenLogChannel(channel)) return;
    _write('RECEBIDO canal=$channel ${_preview(data)}');
  }

  static void parsed({
    required String channel,
    required String event,
    required String session,
    required String? ownSession,
    required int mutationCount,
    required List<String> situacoes,
  }) {
    if (!isListenLogChannel(channel)) return;
    final propriaSessao = session.isNotEmpty && session == ownSession;
    _write(
      'PARSE canal=$channel event=$event session=$session own=$ownSession '
      'propriaSessao=$propriaSessao itens=$mutationCount '
      'situacao=${situacoes.isEmpty ? '-' : situacoes.join(',')}'
      '${mutationCount == 0 ? ' MUTATION_VAZIA' : ''}',
    );
  }

  static void droppedOwnSession({
    required String channel,
    required String event,
  }) {
    if (!isListenLogChannel(channel)) return;
    _write('IGNORADO propria sessao canal=$channel event=$event');
  }

  static void applied({
    required String origem,
    required String situacao,
    String? extra,
  }) {
    final detalhe = extra == null || extra.isEmpty ? '' : ' $extra';
    _write('APLICADO origem=$origem situacao=$situacao$detalhe');
  }

  static void error(String origem, Object error) {
    _write('ERRO origem=$origem $error');
  }

  static int? asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static String? asString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static List<String> situacoesOf(List<Map<String, dynamic>> mutation) {
    return [
      for (final row in mutation)
        if (asString(row['Situacao']) != null) asString(row['Situacao'])!,
    ];
  }

  static void _write(String message) {
    final line = '[$tag] $message';
    debugPrint(line);
    developer.log(line, name: tag);
  }

  static String _preview(dynamic data) {
    final text = data.toString();
    if (text.length <= 800) return text;
    return '${text.substring(0, 800)}…';
  }
}
