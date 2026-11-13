import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/src/manager.dart';
import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class MemorySocket extends io.Socket {
  final sent = <Map<String, dynamic>>[];
  void Function(Map<String, dynamic>)? respond;

  MemorySocket()
    : super(
        Manager(
          uri: 'http://localhost',
          options: {'autoConnect': false, 'reconnection': false},
        ),
        '/',
        {},
      );

  @override
  void emit(String event, [dynamic data]) {
    final body = Map<String, dynamic>.from(jsonDecode(data as String) as Map);
    sent.add({'event': event, ...body});
    respond?.call(body);
  }

  @override
  void packet(Map packet) {} // Sem rede ou servidor real.

  void reply(Map<String, dynamic> body, Object response) {
    emitEvent([body['ResponseIn'], response]);
  }
}

void main() {
  late MemorySocket socket;
  late AppSocketConfig config;
  var reads = 0;
  setUp(() {
    reads = 0;
    socket = MemorySocket();
    config = AppSocketConfig(socketFactory: (_, _) => socket);
    config.initSocket();
    config.recovery.register('documento', () async {
      reads++;
    });
    socket.onconnect('session-1', null);
  });
  tearDown(() {
    config.onClose();
  });

  Future<Map<String, dynamic>> mutate({
    Object mutation = const {'Item': '1'},
  }) => config.request(
    eventSuffix: 'separacao.item.insert',
    payload: {'Mutation': mutation},
    timeout: const Duration(milliseconds: 10),
  );

  test(
    'timeout de mutação não reenvia e exige releitura antes de nova ação',
    () async {
      await expectLater(mutate(), throwsA(isA<AppError>()));
      expect(socket.sent, hasLength(1));
      expect(config.recovery.needsRefresh, isTrue);
      await expectLater(mutate(), throwsA(isA<AppError>()));
      expect(reads, 1);
      expect(socket.sent, hasLength(1));
      socket.respond = (body) => socket.reply(body, {
        'Mutation': [
          {'Item': '2'},
        ],
      });
      await mutate();
      expect(socket.sent, hasLength(2));
    },
  );

  test(
    'queda após emit aborta pendente; reconnect não repete gravação',
    () async {
      socket.respond = (_) => socket.onclose('transport close');
      await expectLater(mutate(), throwsA(isA<AppError>()));
      socket.respond = null;
      socket.onconnect('session-2', null);
      await config.recovery.refresh();
      expect(reads, 1);
      expect(socket.sent, hasLength(1));
      await expectLater(mutate(), throwsA(isA<AppError>()));
      expect(socket.sent, hasLength(1));
    },
  );

  test('timeout de consulta não marca mutação incerta', () async {
    await expectLater(
      config.request(
        eventSuffix: 'separar.consulta',
        timeout: const Duration(milliseconds: 10),
      ),
      throwsA(isA<AppError>()),
    );
    expect(config.recovery.needsRefresh, isFalse);
    expect(reads, 0);
  });

  test(
    'recarga consulta servidor com a sessão nova e substitui estado local',
    () async {
      final grid = [1, 1];
      config.recovery.register('documento', () async {
        final snapshot = await config.request(eventSuffix: 'separar.consulta');
        grid
          ..clear()
          ..addAll((snapshot['Data'] as List).cast<int>());
      });
      socket.respond = (body) => socket.reply(body, {
        'Data': [2, 3],
      });
      socket.onclose('transport close');
      socket.onconnect('session-2', null);
      await config.recovery.refresh();
      expect(grid, [2, 3]);
      expect(socket.sent.single['event'], 'session-2 separar.consulta');
      await expectLater(mutate(), throwsA(isA<AppError>()));
      expect(socket.sent, hasLength(1));
    },
  );

  test(
    'falha de consulta na reconciliação não libera próximo insert',
    () async {
      config.recovery.register('documento', () async {
        await config.request(eventSuffix: 'separar.consulta');
      });
      await expectLater(mutate(), throwsA(isA<AppError>()));
      socket.respond = (body) => socket.reply(body, {
        'Error': ['[SQL-CONN] Falha.'],
      });
      await expectLater(mutate(), throwsA(isA<AppError>()));
      await expectLater(mutate(), throwsA(isA<AppError>()));
      expect(
        socket.sent.where((event) => event['Mutation'] != null),
        hasLength(1),
      );
      expect(config.recovery.needsRefresh, isTrue);
    },
  );

  test(
    'lote com erro pode ter commits parciais; erro de regra único não',
    () async {
      socket.respond = (body) => socket.reply(body, {
        'Error': ['[50014] Regra.'],
      });
      await expectLater(mutate(), throwsA(isA<AppError>()));
      expect(config.recovery.needsRefresh, isFalse);
      await expectLater(
        mutate(
          mutation: [
            {'Item': '1'},
            {'Item': '2'},
          ],
        ),
        throwsA(isA<AppError>()),
      );
      expect(config.recovery.needsRefresh, isTrue);
    },
  );

  test('SQL-CONN e resposta inválida exigem conferir gravação', () async {
    socket.respond = (body) => socket.reply(body, {
      'Error': ['[SQL-CONN] Falha.'],
    });
    await expectLater(mutate(), throwsA(isA<AppError>()));
    expect(config.recovery.needsRefresh, isTrue);
    await expectLater(mutate(), throwsA(isA<AppError>()));
    socket.respond = (body) => socket.reply(body, 'inválido');
    await expectLater(mutate(), throwsA(isA<AppError>()));
    expect(config.recovery.needsRefresh, isTrue);
  });

  test('emergência impede tráfego e não dispara recarga automática', () async {
    config.pauseForServerDisconnect();
    socket.onclose('io server disconnect');
    await expectLater(mutate(), throwsA(isA<AppError>()));
    expect(socket.sent, isEmpty);
    expect(reads, 0);
    expect(socket.io.reconnection, isFalse);
  });
}
