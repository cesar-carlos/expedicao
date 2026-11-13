import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/service/separacao_adicionar_item_service.dart';

import '../app/app_socket_recovery_test.dart' show MemorySocket;
import '../app/two_collectors_recovery_test.dart' show ServerFixture;
import 'carrinho_cadastro_recovery_test.dart' show stage;

void main() {
  late MemorySocket socket;
  late SeparacaoAdicionarItemService service;
  late List<Map<String, dynamic>> history;
  late List<Map<String, dynamic>> rows;
  late List<ExpedicaoSeparacaoItemModel> source;
  var inserts = 0;
  var failView = false;
  setUp(() {
    Get.testMode = true;
    inserts = 0;
    failView = false;
    socket = MemorySocket();
    final config = AppSocketConfig(socketFactory: (_, _) => socket);
    config.initSocket();
    config.recovery.register('documento', () async {
      expect(rows.where((row) => row['Situacao'] != 'CA'), hasLength(1));
    });
    Get.put(config);
    Get.put(ProcessoExecutavelModel.empty());
    socket.onconnect('recovery-test', null);
    history = [
      stage(item: '9', situation: 'CANCELADA').toJson(),
      stage(item: '10', situation: 'SEPARANDO').toJson(),
    ];
    final target = ExpedicaoCarrinhoPercursoEstagioConsultaModel.fromJson({
      ...history.last,
      'NomeCarrinho': 'Teste',
      'CodigoBarrasCarrinho': '4',
      'Ativo': 'S',
      'CarrinhoAgrupador': 'N',
    });
    service = SeparacaoAdicionarItemService(percursoEstagioConsulta: target);
    rows = [
      {
        ...ServerFixture('separacao.item').makeRow(1, 5, 'old'),
        'CodSepararEstoque': 71,
        'CodCarrinhoPercurso': 10,
        'ItemCarrinhoPercurso': '00009',
        'Situacao': 'CA',
      },
    ];
    source = rows.map(ExpedicaoSeparacaoItemModel.fromJson).toList();
    socket.respond = (body) {
      final event = (socket.sent.last['event'] as String).split(' ').last;
      if (event == 'separacao.item.insert') {
        inserts++;
        final row = {
          ...rows.first,
          ...Map<String, dynamic>.from(body['Mutation']),
          'Item': '${inserts + 1}',
        };
        rows.add(row);
        socket.reply(body, {'Mutation': row});
        return;
      }
      if (event == 'separacao.item.consulta' && failView) {
        socket.reply(body, {
          'Error': ['[50014] Falha simulada após gravação.'],
        });
        return;
      }
      final List<Map<String, dynamic>> result;
      switch (event) {
        case 'carrinho.percurso.estagio.select':
          result = history;
        case 'carrinho.select':
          result = [
            {
              'CodEmpresa': 1,
              'CodCarrinho': 4,
              'Descricao': 'Teste',
              'Ativo': 'S',
              'CodigoBarras': '4',
              'Situacao': 'EM SEPARACAO',
            },
          ];
        case 'separar.select':
          result = [
            {
              'CodEmpresa': 1,
              'CodSepararEstoque': 71,
              'Origem': 'PV',
              'CodOrigem': 1,
              'CodTipoOperacaoExpedicao': 1,
              'TipoEntidade': 'C',
              'CodEntidade': 1,
              'NomeEntidade': 'Teste',
              'Situacao': 'SEPARANDO',
              'Data': '2026-11-13',
              'CodPrioridade': 1,
            },
          ];
        case 'separar.item.select':
          result = [
            {
              'CodEmpresa': 1,
              'CodSepararEstoque': 71,
              'Item': '1',
              'Origem': 'PV',
              'CodOrigem': 1,
              'CodLocalArmazenagem': 1,
              'CodProduto': 123,
              'CodUnidadeMedida': 'UN',
              'Quantidade': '20',
              'QuantidadeInterna': '20',
              'QuantidadeExterna': '0',
              'QuantidadeSeparacao': '0',
            },
          ];
        case 'separacao.item.select':
          result = rows;
        case 'separacao.item.consulta':
          result = [rows.last];
        default:
          throw StateError('Consulta inesperada: $event');
      }
      socket.reply(body, {'Data': result});
    };
  });
  tearDown(() {
    Get.reset();
  });
  test('F11 repetido relê destino e não copia novamente', () async {
    expect(await service.addRecuperados(source), hasLength(1));
    expect(await service.addRecuperados(source), isEmpty);
    expect(inserts, 1);
  });
  test('cancelamento parcial recusa antes de inserir', () async {
    rows.first['Situacao'] = 'SP';
    await expectLater(service.addRecuperados(source), throwsException);
    expect(inserts, 0);
  });
  test('reutilização em outro documento recusa antes de inserir', () async {
    history.add(
      stage(percurso: 11, document: 72, situation: 'SEPARANDO').toJson(),
    );
    await expectLater(service.addRecuperados(source), throwsException);
    expect(inserts, 0);
  });
  test(
    'falha de leitura após commit exige revisão e retomada não duplica',
    () async {
      failView = true;
      await expectLater(service.addRecuperados(source), throwsException);
      expect(inserts, 1);
      failView = false;
      await expectLater(service.addRecuperados(source), throwsException);
      expect(await service.addRecuperados(source), isEmpty);
      expect(inserts, 1);
    },
  );
}
