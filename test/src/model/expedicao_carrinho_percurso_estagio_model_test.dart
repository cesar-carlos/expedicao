import 'package:flutter_test/flutter_test.dart';

import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';

void main() {
  group('ExpedicaoCarrinhoPercursoEstagioModel.reabrir', () {
    test('volta para SEPARANDO e zera auditoria de finalização', () {
      final estagio = ExpedicaoCarrinhoPercursoEstagioModel(
        codEmpresa: 1,
        codCarrinhoPercurso: 10,
        item: '00001',
        origem: 'SEP',
        codOrigem: 28,
        codPercursoEstagio: 1,
        codCarrinho: 9,
        situacao: ExpedicaoSituacaoModel.separado,
        dataInicio: DateTime(2026, 8, 15, 8),
        horaInicio: '08:00:00',
        codUsuarioInicio: 1,
        nomeUsuarioInicio: 'Admin',
        dataFinalizacao: DateTime(2026, 8, 15, 10),
        horaFinalizacao: '10:00:00',
        codUsuarioFinalizacao: 2,
        nomeUsuarioFinalizacao: 'Operador',
      );

      final reaberto = estagio.reabrir();

      expect(reaberto.situacao, ExpedicaoSituacaoModel.separando);
      expect(reaberto.dataFinalizacao, isNull);
      expect(reaberto.horaFinalizacao, isNull);
      expect(reaberto.codUsuarioFinalizacao, isNull);
      expect(reaberto.nomeUsuarioFinalizacao, isNull);
      expect(reaberto.codCarrinho, estagio.codCarrinho);
      expect(reaberto.item, estagio.item);
      expect(reaberto.codUsuarioInicio, estagio.codUsuarioInicio);
    });
  });

  group('ExpedicaoCarrinhoPercursoEstagioConsultaModel.reabrir', () {
    test('volta para SEPARANDO e zera auditoria de finalização', () {
      final consulta = ExpedicaoCarrinhoPercursoEstagioConsultaModel(
        codEmpresa: 1,
        codCarrinhoPercurso: 10,
        item: '00001',
        codPercursoEstagio: 1,
        origem: 'SEP',
        codOrigem: 28,
        situacao: ExpedicaoSituacaoModel.separado,
        carrinhoAgrupador: 'N',
        codCarrinho: 9,
        nomeCarrinho: 'Carrinho 9',
        codigoBarrasCarrinho: '123',
        ativo: 'S',
        codUsuarioInicio: 1,
        nomeUsuarioInicio: 'Admin',
        dataInicio: DateTime(2026, 8, 15, 8),
        horaInicio: '08:00:00',
        codUsuarioFinalizacao: 2,
        nomeUsuarioFinalizacao: 'Operador',
        dataFinalizacao: DateTime(2026, 8, 15, 10),
        horaFinalizacao: '10:00:00',
      );

      final reaberto = consulta.reabrir();

      expect(reaberto.situacao, ExpedicaoSituacaoModel.separando);
      expect(reaberto.dataFinalizacao, isNull);
      expect(reaberto.horaFinalizacao, isNull);
      expect(reaberto.codUsuarioFinalizacao, isNull);
      expect(reaberto.nomeUsuarioFinalizacao, isNull);
    });
  });
}
