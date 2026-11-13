import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_consulta_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_agrupar_service.dart';
import 'package:app_expedicao/src/service/carrinho_recovery_validation.dart';

import '../app/app_socket_recovery_test.dart' show MemorySocket;

class GroupFixture {
  final socket = MemorySocket();
  late final AppSocketConfig config;
  final stages = <Map<String, dynamic>>[];
  final groups = <Map<String, dynamic>>[];
  final carts = <Map<String, dynamic>>[];
  int writes = 0;
  int failAt = 0;
  GroupFixture({bool grouped = false}) {
    config = AppSocketConfig(socketFactory: (_, _) => socket);
    config.initSocket();
    Get.put(config);
    Get.put(
      ProcessoExecutavelModel.empty().copyWith(
        codUsuario: 7,
        nomeUsuario: 'Teste',
      ),
    );
    socket.onconnect('group-test', null);
    for (var cart = 1; cart <= 2; cart++) {
      stages.add({
        'CodEmpresa': 1,
        'CodCarrinhoPercurso': 10,
        'Item': '$cart',
        'Origem': 'CO',
        'CodOrigem': 71,
        'CodPercursoEstagio': 8,
        'CodCarrinho': cart,
        'Situacao': grouped && cart == 2 ? 'AGRUPADO' : 'CONFERIDO',
        'DataInicio': '2026-11-13',
        'HoraInicio': '10:00:00',
        'CodUsuarioInicio': 7,
        'NomeUsuarioInicio': 'Teste',
      });
      carts.add({
        'CodEmpresa': 1,
        'CodCarrinho': cart,
        'Descricao': 'Carrinho $cart',
        'Ativo': 'S',
        'CodigoBarras': '$cart',
        'Situacao': grouped && cart == 2 ? 'LIBERADO' : 'CONFERIDO',
      });
    }
    if (grouped) {
      groups.add({
        'CodEmpresa': 1,
        'CodCarrinhoPercurso': 10,
        'Item': '9',
        'Origem': 'CO',
        'ItemCarrinhoPercurso': '2',
        'Situacao': 'AGRUPADO',
        'CodCarrinhoAgrupador': 1,
        'DataLancamento': '2026-11-13',
        'HoraLancamento': '10:00:00',
        'CodUsuarioLancamento': 7,
        'NomeUsuarioLancamento': 'Teste',
      });
    }
    socket.respond = receive;
    config.recovery.register('grade', () async {});
    config.recovery.registerValidator(
      'grade',
      () => CarrinhoRecoveryValidation.reloadAndValidate(
        codEmpresa: 1,
        codDocumento: 71,
        conferencia: true,
      ),
    );
  }
  ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel view(int cart) {
    final s = stages.firstWhere(
      (s) => s['CodCarrinho'] == cart && s['CodCarrinhoPercurso'] == 10,
    );
    final links = groups
        .where(
          (g) =>
              g['Situacao'] != 'CANCELADA' &&
              g['ItemCarrinhoPercurso'].toString() == '$cart',
        )
        .toList();
    final link = links.isEmpty ? null : links.single;
    return ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel(
      codEmpresa: 1,
      codCarrinhoPercurso: 10,
      itemAgrupamento: link?['Item'],
      itemCarrinhoPercurso: '$cart',
      origem: 'CO',
      codOrigem: 71,
      situacao: link?['Situacao'] ?? s['Situacao'],
      situacaoPercurso: 'CONFERINDO',
      codCarrinhoAgrupador: link?['CodCarrinhoAgrupador'],
      codCarrinho: cart,
      nomeCarrinho: 'Carrinho $cart',
      codigoBarrasCarrinho: '$cart',
      carrinhoAgrupador:
          groups.any(
            (g) =>
                g['Situacao'] != 'CANCELADA' &&
                g['CodCarrinhoAgrupador'] == cart,
          )
          ? 'S'
          : 'N',
      dataInicio: DateTime(2026, 11, 13),
      horaInicio: '10:00:00',
      codUsuarioInicio: 7,
      nomeUsuarioInicio: 'Teste',
    );
  }

  bool matches(Map<String, dynamic> row, List filters) => filters.every((p) {
    final value = row[p['key']];
    final expected = p['value'];
    if (p['operator'] == 'IN') return (expected as List).contains(value);
    bool same = value == expected;
    if ((p['key'] as String).startsWith('Item')) {
      same = int.tryParse('$value') == int.tryParse('$expected');
    }
    return p['operator'] == '!=' ? !same : same;
  });
  void receive(Map<String, dynamic> body) {
    final event = (socket.sent.last['event'] as String).split(' ').last;
    if (body.containsKey('Mutation')) {
      writes++;
      if (writes == failAt) {
        socket.reply(body, {
          'Error': ['[50014] Falha simulada.'],
        });
        return;
      }
      final row = Map<String, dynamic>.from(body['Mutation'] as Map);
      if (event == 'carrinho.update') {
        carts[carts.indexWhere((c) => c['CodCarrinho'] == row['CodCarrinho'])] =
            row;
      }
      if (event == 'carrinho.percurso.estagio.update') {
        stages[stages.indexWhere(
              (s) => int.parse(s['Item']) == int.parse(row['Item']),
            )] =
            row;
      }
      if (event == 'carrinho.percurso.agrupamento.insert') {
        row['Item'] = '9';
        groups.add(row);
      }
      if (event == 'carrinho.percurso.agrupamento.update') groups[0] = row;
      socket.reply(body, {'Mutation': row});
      return;
    }
    final rows = switch (event) {
      'carrinho.percurso.agrupamento.consulta' =>
        carts.map((cart) => view(cart['CodCarrinho']).toJson()).toList(),
      'carrinho.percurso.estagio.select' => stages,
      'carrinho.percurso.agrupamento.select' => groups,
      'carrinho.select' => carts,
      _ => <Map<String, dynamic>>[],
    };
    socket.reply(body, {
      'Data': rows.where((row) => matches(row, body['Where'] ?? [])).toList(),
    });
  }

  Future<void> act(bool ungroup) {
    final service = CarrinhoPercursoEstagioAgruparService(
      codEmpresa: 1,
      codCarrinhoPercurso: 10,
    );
    return ungroup
        ? service.cancelarAgrupamento(view(2))
        : service.agruparCarrinho(view(1), view(2));
  }
}

void main() {
  setUp(() {
    Get.testMode = true;
  });
  tearDown(() {
    Get.reset();
  });
  for (final ungroup in [false, true]) {
    final operation = ungroup ? 'desagrupar' : 'agrupar';
    final total = ungroup ? 4 : 3;
    test(
      '$operation tudo interrompe no segundo carrinho sem começar o terceiro',
      () async {
        final f = GroupFixture(grouped: ungroup);
        for (final cart in [3, 4]) {
          f.stages.add({...f.stages[1], 'Item': '$cart', 'CodCarrinho': cart});
          f.carts.add({...f.carts[1], 'CodCarrinho': cart});
          if (ungroup) {
            f.groups.add({
              ...f.groups.first,
              'Item': '${cart + 8}',
              'ItemCarrinhoPercurso': '$cart',
            });
          }
        }
        f.failAt = total + 2;
        final service = CarrinhoPercursoEstagioAgruparService(
          codEmpresa: 1,
          codCarrinhoPercurso: 10,
        );
        await expectLater(
          ungroup
              ? service.cancelarTodosAgrupamento(f.view(1))
              : service.agruparTodosCarrinho(f.view(1)),
          throwsA(anything),
        );
        expect(f.writes, total + 2);
        expect(f.stages[1]['Situacao'], ungroup ? 'CONFERIDO' : 'AGRUPADO');
        expect(f.stages[3]['Situacao'], ungroup ? 'AGRUPADO' : 'CONFERIDO');
        expect(f.carts[3]['Situacao'], ungroup ? 'LIBERADO' : 'CONFERIDO');
        expect(f.config.recovery.needsRefresh, isTrue);
        await expectLater(f.config.recovery.refresh(), throwsA(anything));
        expect(f.writes, total + 2);
      },
    );
    test('$operation conclui sem alterar itens ou cadastro destino', () async {
      final f = GroupFixture(grouped: ungroup);
      await f.act(ungroup);
      expect(f.writes, total);
      expect(f.carts[0]['Situacao'], 'CONFERIDO');
      expect(f.carts[1]['Situacao'], ungroup ? 'CONFERIDO' : 'LIBERADO');
      expect(f.stages[1]['Situacao'], ungroup ? 'CONFERIDO' : 'AGRUPADO');
      expect(f.groups.single['Situacao'], ungroup ? 'CANCELADA' : 'AGRUPADO');
      expect(
        f.socket.sent
            .where((e) => e.containsKey('Mutation'))
            .any((e) => (e['event'] as String).contains('.item.')),
        isFalse,
      );
      await CarrinhoRecoveryValidation.reloadAndValidate(
        codEmpresa: 1,
        codDocumento: 71,
        conferencia: true,
      );
    });
    for (var failure = 1; failure <= total; failure++) {
      test(
        '$operation para na gravação $failure e preserva bloqueio se houve commit',
        () async {
          final f = GroupFixture(grouped: ungroup)..failAt = failure;
          await expectLater(f.act(ungroup), throwsA(anything));
          expect(f.writes, failure);
          expect(f.config.recovery.needsRefresh, failure > 1);
          if (failure > 1) {
            await expectLater(f.config.recovery.refresh(), throwsA(anything));
            expect(f.config.recovery.needsRefresh, isTrue);
            expect(f.writes, failure);
          }
        },
      );
    }
    for (final reused in [1, 2]) {
      test(
        '$operation recusa carrinho $reused reutilizado mesmo com cadastro compatível',
        () async {
          final f = GroupFixture(grouped: ungroup);
          f.stages.add({
            ...f.stages[reused - 1],
            'CodCarrinhoPercurso': 11,
            'CodOrigem': 99,
            'Situacao': 'CANCELADA',
          });
          await expectLater(f.act(ungroup), throwsA(anything));
          expect(f.writes, 0);
        },
      );
    }
  }
  test('não agrupa entre documentos diferentes', () async {
    final f = GroupFixture();
    final service = CarrinhoPercursoEstagioAgruparService(
      codEmpresa: 1,
      codCarrinhoPercurso: 10,
    );
    await expectLater(
      service.agruparCarrinho(f.view(1), f.view(2).copyWith(codOrigem: 99)),
      throwsA(anything),
    );
    expect(f.writes, 0);
  });
  test(
    'não cria outro vínculo quando vínculo ativo informa CONFERIDO',
    () async {
      final f = GroupFixture(grouped: true);
      f.groups.single['Situacao'] = 'CONFERIDO';
      f.carts[1]['Situacao'] = 'CONFERIDO';
      f.stages[1]['Situacao'] = 'CONFERIDO';
      await expectLater(f.act(false), throwsA(anything));
      expect(f.writes, 0);
    },
  );
  test('recuperação bloqueia dois vínculos ativos do mesmo estágio', () async {
    final f = GroupFixture(grouped: true);
    f.groups.add({...f.groups.single, 'Item': '10'});
    await expectLater(
      CarrinhoRecoveryValidation.reloadAndValidate(
        codEmpresa: 1,
        codDocumento: 71,
        conferencia: true,
      ),
      throwsA(anything),
    );
    expect(f.writes, 0);
  });
}
