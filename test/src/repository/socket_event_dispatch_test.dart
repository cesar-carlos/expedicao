import 'package:flutter_test/flutter_test.dart';

import 'package:app_expedicao/src/model/basic_event_model.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/repository/socket_event_repository.dart';

void main() {
  group('SocketEventRepository.dispatch', () {
    test('decodifica uma vez e notifica só o evento pedido', () {
      final received = <BasicEventModel>[];
      final listeners = [
        RepositoryEventListenerModel(
          id: 'insert',
          event: Event.insert,
          callback: received.add,
        ),
        RepositoryEventListenerModel(
          id: 'update',
          event: Event.update,
          callback: received.add,
        ),
      ];

      SocketEventRepository.dispatch(
        listeners: listeners,
        event: Event.insert,
        data: {
          'Session': 'other',
          'ResponseIn': 'r1',
          'Mutation': [
            {'CodEmpresa': 1},
          ],
        },
        sessionId: 'mine',
      );

      expect(received, hasLength(1));
      expect(received.single.session, 'other');
      expect(received.single.mutation, [
        {'CodEmpresa': 1},
      ]);
    });

    test('ignora o próprio session salvo allEvent', () {
      final received = <String>[];
      final listeners = [
        RepositoryEventListenerModel(
          id: 'own',
          event: Event.update,
          callback: (_) => received.add('own'),
        ),
        RepositoryEventListenerModel(
          id: 'all',
          event: Event.update,
          allEvent: true,
          callback: (_) => received.add('all'),
        ),
      ];

      SocketEventRepository.dispatch(
        listeners: listeners,
        event: Event.update,
        data: {
          'Session': 'mine',
          'ResponseIn': 'r1',
          'Mutation': {'Item': '001'},
        },
        sessionId: 'mine',
      );

      expect(received, ['all']);
    });

    test('não faz nada com lista vazia', () {
      SocketEventRepository.dispatch(
        listeners: const [],
        event: Event.delete,
        data: 'não é json',
        sessionId: 's',
      );
    });

    test('allEvent recebe o update da própria sessão', () {
      final received = <String>[];
      final listeners = [
        RepositoryEventListenerModel(
          id: 'situacao',
          event: Event.update,
          allEvent: true,
          callback: (event) {
            received.add(event.mutation.first['Situacao'] as String);
          },
        ),
      ];

      SocketEventRepository.dispatch(
        listeners: listeners,
        event: Event.update,
        channel: 'separar.update.listen',
        data: {
          'Session': 'mine',
          'ResponseIn': 'r1',
          'Mutation': {
            'CodEmpresa': 1,
            'CodSepararEstoque': 290500,
            'Situacao': 'SEPARADO',
          },
        },
        sessionId: 'mine',
      );

      expect(received, ['SEPARADO']);
    });
  });
}
