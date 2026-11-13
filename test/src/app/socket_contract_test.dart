import 'package:flutter_test/flutter_test.dart';
import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

import 'app_socket_recovery_test.dart' show MemorySocket;

void main() {
  late MemorySocket socket;
  late AppSocketConfig config;
  setUp(() {
    socket = MemorySocket();
    config = AppSocketConfig(socketFactory: (_, _) => socket)..initSocket();
    socket.onconnect('current-session', null);
  });
  tearDown(() => config.onClose());

  Future<List<Map<String, dynamic>>> query([QueryBuilder? builder]) =>
      config.queryMapped(
        eventSuffix: 'separar.consulta',
        queryBuilder: builder ?? QueryBuilder(),
        fromJson: (row) => row,
      );

  for (final invalid in [
    null,
    'invalid',
    42,
    [null],
    [
      {'Item': '1'},
      false,
    ],
  ]) {
    test(
      'consulta não converte resposta inválida $invalid em lista vazia/parcial',
      () async {
        socket.respond = (body) => socket.reply(body, {'Data': invalid});
        await expectLater(query(), throwsA(isA<AppError>()));
      },
    );
  }

  test('lista vazia explícita é sucesso; objeto único e Mutation legado continuam aceitos', () async {
    socket.respond = (body) => socket.reply(body, {'Data': []});
    expect(await query(), isEmpty);
    socket.respond = (body) => socket.reply(body, {
      'Mutation': {'Item': '1'},
    });
    expect(await query(), [
      {'Item': '1'},
    ]);
  });

  test('mutação com linhas malformadas exige reconciliação', () async {
    socket.respond = (body) => socket.reply(body, {
      'Mutation': [
        {'Item': '1'},
        null,
      ],
    });
    await expectLater(
      config.mutateMapped(
        eventSuffix: 'separacao.item.insert',
        mutation: {'Quantidade': 1},
        fromJson: (row) => row,
      ),
      throwsA(isA<AppError>()),
    );
    expect(config.recovery.needsRefresh, isTrue);
  });

  test(
    'payload não sobrescreve sessão nem UUID; valores congelam antes da espera',
    () async {
      final payload = <String, dynamic>{
        'Session': 'old-session',
        'ResponseIn': 'old-id',
        'Mutation': [
          {'Quantidade': 1},
        ],
      };
      socket.respond = (body) => socket.reply(body, {'Mutation': []});
      final pending = config.request(
        eventSuffix: 'separacao.item.insert',
        payload: payload,
      );
      (payload['Mutation'] as List).first['Quantidade'] = 99;
      await pending;
      final sent = socket.sent.single;
      expect(sent['Session'], 'current-session');
      expect(sent['ResponseIn'], isNot('old-id'));
      expect(sent['Mutation'], [
        {'Quantidade': 1},
      ]);
    },
  );

  for (final key in ['Session', 'ResponseIn']) {
    test('rejeita resposta com $key de outro pedido', () async {
      socket.respond = (body) =>
          socket.reply(body, {key: 'different', 'Data': []});
      await expectLater(query(), throwsA(isA<AppError>()));
    });
  }

  test('todas as páginas usam filtros e ordem capturados no início', () async {
    final values = [1, 2];
    final builder = QueryBuilder()
        .addParam('CodEmpresa', values, operator: 'IN')
        .allRows(pageSize: 1);
    socket.respond = (body) {
      if (socket.sent.length == 1) {
        values.add(3);
        builder.clear();
        socket.reply(body, {
          'Data': [
            {'Item': '1'},
          ],
        });
      } else {
        socket.reply(body, {'Data': []});
      }
    };
    expect(await query(builder), [
      {'Item': '1'},
    ]);
    expect(socket.sent, hasLength(2));
    for (final sent in socket.sent) {
      expect(sent['Where'], [
        {
          'key': 'CodEmpresa',
          'operator': 'IN',
          'value': [1, 2],
        },
      ]);
      expect(sent['OrderBy'], 'order_by=Item&order_direction=ASC');
    }
    expect(socket.sent.last['Pagination'], 'LIMIT=1&OFFSET=1&PAGE=2');
  });

  test('não mistura páginas de sessões diferentes', () async {
    config.recovery.register('document', () async {});
    socket.respond = (body) {
      socket.reply(body, {
        'Data': [
          {'Item': '1'},
        ],
      });
      socket.onclose('transport close');
      socket.onconnect('new-session', null);
    };
    await expectLater(
      query(QueryBuilder().allRows(pageSize: 1)),
      throwsA(isA<AppError>()),
    );
    expect(socket.sent, hasLength(1));
    await config.recovery.refresh();
  });
}
