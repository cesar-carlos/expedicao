import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_consulta_model.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separacao/separacao_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/repository/socket_event_repository.dart';

import 'app_socket_recovery_test.dart' show MemorySocket;

enum Fault { none, beforeCommit, afterCommit, partialBatch, lostReply }

// Dois transportes independentes compartilham apenas o estado do servidor.
// Não acessa API/SQL real nem substitui homologação em dois executáveis Windows.
class ServerFixture {
  final String resource;
  final rows = <Map<String, dynamic>>[];
  final clients = <CollectorFixture>[];
  Fault nextFault = Fault.none;
  bool failReads = false;
  int insertRequests = 0;
  int queries = 0;
  int sequence = 0;
  void Function()? duringNextRead;

  ServerFixture(this.resource);

  void receive(CollectorFixture source, Map<String, dynamic> body) {
    final event = source.socket.sent.last['event'] as String;
    expect(event, startsWith('${source.socket.id} '));
    if (event.endsWith('.consulta')) {
      queries++;
      if (failReads) {
        source.socket.reply(
          body,
          jsonEncode({
            'Error': ['[SQL-CONN] Consulta indisponível.'],
          }),
        );
        return;
      }
      final snapshot = rows.map((row) => Map<String, dynamic>.of(row)).toList();
      final change = duringNextRead;
      duringNextRead = null;
      change?.call();
      source.socket.reply(body, jsonEncode({'Data': snapshot}));
      return;
    }
    expect(event, endsWith('$resource.insert'));
    insertRequests++;
    final fault = nextFault;
    nextFault = Fault.none;
    if (fault == Fault.beforeCommit) {
      source.socket.onclose('transport close');
      return;
    }
    final mutation = body['Mutation'];
    final inputs = mutation is List ? mutation : [mutation];
    final committed = <Map<String, dynamic>>[];
    for (final input in inputs) {
      final row = makeRow(
        ++sequence,
        (input as Map)['Quantidade'] as num,
        body['Session'] as String,
      );
      rows.add(row);
      committed.add(row);
      if (fault == Fault.partialBatch) break;
    }
    if (fault == Fault.afterCommit || fault == Fault.partialBatch) {
      source.socket.onclose('transport close');
    }
    broadcast(committed, body['Session'] as String);
    if (fault == Fault.afterCommit ||
        fault == Fault.partialBatch ||
        fault == Fault.lostReply) {
      return;
    }
    source.socket.reply(body, jsonEncode({'Mutation': committed}));
  }

  void broadcast(List<Map<String, dynamic>> changed, String session) {
    for (final client in clients) {
      if (client.socket.connected) {
        client.socket.emitEvent([
          '$resource.insert.listen',
          jsonEncode({'Session': session, 'Mutation': changed}),
        ]);
      }
    }
  }

  Map<String, dynamic> makeRow(int id, num quantity, String session) => {
    'CodEmpresa': 1,
    'CodSepararEstoque': 10,
    'CodConferir': 10,
    'Item': id.toString().padLeft(5, '0'),
    'SessionId': session,
    'Situacao': resource == 'separacao.item' ? 'SP' : 'CF',
    'CodCarrinho': 94,
    'NomeCarrinho': 'Carrinho de teste',
    'CodigoBarrasCarrinho': '94',
    'CodCarrinhoPercurso': 100,
    'ItemCarrinhoPercurso': '00001',
    'CodProduto': 123,
    'NomeProduto': 'Produto de teste',
    'CodUnidadeMedida': 'UN',
    'NomeUnidadeMedida': 'Unidade',
    'CodGrupoProduto': 1,
    'NomeGrupoProduto': 'Grupo',
    'CodSeparador': 1,
    'NomeSeparador': 'Teste',
    'CodConferente': 1,
    'NomeConferente': 'Teste',
    'DataSeparacao': '2026-11-13',
    'HoraSeparacao': '10:00:00',
    'DataConferencia': '2026-11-13',
    'HoraConferencia': '10:00:00',
    'Quantidade': quantity.toString(),
  };
}

class CollectorFixture {
  final ServerFixture server;
  final String name;
  final socket = MemorySocket();
  final separationGrid = SeparacaoCarrinhoGridController();
  final checkingGrid = ConferenciaCarrinhoGridController();
  late final AppSocketConfig config;
  int generation = 0;

  CollectorFixture(this.server, this.name) {
    config = AppSocketConfig(socketFactory: (_, _) => socket);
    socket.respond = (body) => server.receive(this, body);
    final listener = RepositoryEventListenerModel(
      id: name,
      event: Event.insert,
      allEvent: false,
      callback: (data) {
        for (final row in data.mutation) {
          add(row);
        }
      },
    );
    config.listen('${server.resource}.insert.listen', (data) {
      config.recovery.receivedChange();
      SocketEventRepository.dispatch(
        listeners: [listener],
        event: Event.insert,
        data: data,
        sessionId: config.sessionId,
      );
    });
    config.recovery.register(this, reload);
    config.initSocket();
    server.clients.add(this);
    socket.onconnect('$name-${++generation}', null);
  }

  bool get separation => server.resource == 'separacao.item';
  List<String> get keys => separation
      ? separationGrid.itens.map((row) => row.item).toList()
      : checkingGrid.itens.map((row) => row.item).toList();
  double get quantity => separation
      ? separationGrid.totalQuantity()
      : checkingGrid.totalQuantity();

  void add(Map<String, dynamic> row) {
    if (separation) {
      separationGrid.addGrid(ExpedicaSeparacaoItemConsultaModel.fromJson(row));
    } else {
      checkingGrid.addGrid(ExpedicaConferenciaItemConsultaModel.fromJson(row));
    }
  }

  Future<void> reload() async {
    final response = await config.request(
      eventSuffix: '${server.resource}.consulta',
    );
    // Mesmo caminho de substituição usado pelos controllers de carrinho.
    if (separation) {
      separationGrid.removeAllGrid();
      separationGrid.addAllGrid(
        (response['Data'] as List)
            .map(
              (row) => ExpedicaSeparacaoItemConsultaModel.fromJson(
                Map<String, dynamic>.from(row as Map),
              ),
            )
            .toList(),
      );
    } else {
      checkingGrid.removeAllGrid();
      checkingGrid.addAllGrid(
        (response['Data'] as List)
            .map(
              (row) => ExpedicaConferenciaItemConsultaModel.fromJson(
                Map<String, dynamic>.from(row as Map),
              ),
            )
            .toList(),
      );
    }
  }

  Future<void> insert(List<num> quantities) async {
    final response = await config.request(
      eventSuffix: '${server.resource}.insert',
      payload: {
        'Mutation': quantities.map((q) => {'Quantidade': q}).toList(),
      },
      timeout: const Duration(milliseconds: 20),
    );
    for (final row in response['Mutation'] as List) {
      add(Map<String, dynamic>.from(row as Map));
    }
  }

  Future<void> reconnect() async {
    socket.onconnect('$name-${++generation}', null);
    await config.recovery.refresh();
  }

  void dispose() {
    config.recovery.unregister(this);
    config.onClose();
    separationGrid.onClose();
    separationGrid.dataGridController.dispose();
    checkingGrid.onClose();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  for (final resource in ['separacao.item', 'conferencia.item']) {
    group('Dois coletores / $resource', () {
      late ServerFixture server;
      late CollectorFixture a;
      late CollectorFixture b;
      setUp(() {
        server = ServerFixture(resource);
        a = CollectorFixture(server, 'A');
        b = CollectorFixture(server, 'B');
      });
      tearDown(() {
        a.dispose();
        b.dispose();
      });

      void expectConsistent(int count, num total) {
        expect(server.rows, hasLength(count));
        for (final client in [a, b]) {
          expect(client.keys, hasLength(count));
          expect(
            client.keys.toSet(),
            hasLength(count),
            reason: 'Chaves únicas em ${client.name}',
          );
          expect(
            client.keys.toSet(),
            server.rows
                .map((row) => int.parse(row['Item'] as String).toString())
                .toSet(),
          );
          expect(client.quantity, total);
        }
      }

      test(
        'commit + queda, B grava com A offline, reconexões não duplicam',
        () async {
          server.nextFault = Fault.afterCommit;
          await expectLater(a.insert([1]), throwsA(isA<AppError>()));
          expect(a.keys, isEmpty);
          expect(b.quantity, 1);
          await b.insert([2]);
          expect(
            b.keys,
            hasLength(2),
          ); // Broadcast próprio não somou novamente.
          await a.reconnect();
          expectConsistent(2, 3);
          await expectLater(a.insert([1]), throwsA(isA<AppError>()));
          expect(server.insertRequests, 2); // A tentativa de repetir não saiu.
          for (var i = 0; i < 3; i++) {
            a.socket.onclose('transport close');
            await a.reconnect();
            expectConsistent(2, 3);
          }
          expect(server.insertRequests, 2);
        },
      );

      test(
        'queda antes do commit: snapshot vazio, revisão e nova ação única',
        () async {
          server.nextFault = Fault.beforeCommit;
          await expectLater(a.insert([1]), throwsA(isA<AppError>()));
          await a.reconnect();
          expectConsistent(0, 0);
          await expectLater(a.insert([1]), throwsA(isA<AppError>()));
          expect(server.insertRequests, 1);
          await a.insert([1]);
          expectConsistent(1, 1);
          expect(server.insertRequests, 2);
        },
      );

      test(
        'lote parcial: releitura mostra apenas commits e não repete lote',
        () async {
          server.nextFault = Fault.partialBatch;
          await expectLater(a.insert([1, 2]), throwsA(isA<AppError>()));
          await b.insert([3]);
          await a.reconnect();
          expectConsistent(2, 4);
          await expectLater(a.insert([1, 2]), throwsA(isA<AppError>()));
          expect(server.insertRequests, 2);
          await a.insert([2]); // Operador executa somente o que ficou faltando.
          expectConsistent(3, 6);
        },
      );

      test(
        'resposta perdida sem desconexão: timeout não duplica insert',
        () async {
          server.nextFault = Fault.lostReply;
          await expectLater(a.insert([1]), throwsA(isA<AppError>()));
          expect(a.socket.connected, isTrue);
          expect(
            a.keys,
            isEmpty,
          ); // Sessão própria ignorada; resposta não chegou.
          expect(b.quantity, 1);
          await expectLater(a.insert([1]), throwsA(isA<AppError>()));
          expectConsistent(1, 1);
          expect(server.insertRequests, 1);
        },
      );

      test(
        'falha no snapshot mantém bloqueio; recuperação posterior converge',
        () async {
          server.nextFault = Fault.afterCommit;
          await expectLater(a.insert([1]), throwsA(isA<AppError>()));
          server.failReads = true;
          await expectLater(a.reconnect(), throwsA(isA<AppError>()));
          await expectLater(a.insert([1]), throwsA(isA<AppError>()));
          expect(server.insertRequests, 1);
          expect(a.config.recovery.needsRefresh, isTrue);
          server.failReads = false;
          await expectLater(a.insert([1]), throwsA(isA<AppError>()));
          expectConsistent(1, 1);
          expect(server.insertRequests, 1);
        },
      );

      test(
        'broadcast durante snapshot antigo força releitura sem duplicar',
        () async {
          await b.insert([1]);
          a.socket.onclose('transport close');
          server.duringNextRead = () {
            final row = server.makeRow(++server.sequence, 2, b.socket.id!);
            server.rows.add(row);
            b.add(row); // Aplicação local da resposta do outro coletor.
            server.broadcast([row], b.socket.id!);
          };
          await a.reconnect();
          expect(server.queries, 2);
          expectConsistent(2, 3);
        },
      );
    });
  }
}
