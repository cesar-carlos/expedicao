import 'package:get/get.dart';
import 'package:app_expedicao/src/app/app_error_alert.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_model.dart';
import 'package:app_expedicao/src/repository/expedicao_cancelamento/cancelamento_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso_agrupamento/carrinho_percurso_agrupamento_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso_agrupamento/carrinho_percurso_agrupamento_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/model/expedicao_cancelamento_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';

class CarrinhoPercursoEstagioAgruparService {
  final int codEmpresa;
  final int codCarrinhoPercurso;

  final _processo = Get.find<ProcessoExecutavelModel>();

  final carrinhoPercursoAgrupamentoRepository =
      CarrinhoPercursoAgrupamentoRepository();
  final cancelamentoRepository = CancelamentoRepository();
  final carrinhoPercursoEstagioRepository = CarrinhoPercursoEstagioRepository();
  final carrinhoRepository = CarrinhoRepository();
  final carrinhoPercursoAgrupamentoConsultaRepository =
      CarrinhoPercursoAgrupamentoConsultaRepository();

  CarrinhoPercursoEstagioAgruparService({
    required this.codEmpresa,
    required this.codCarrinhoPercurso,
  });

  static Future<List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>>
      consulta([QueryBuilder? queryBuilder]) async {
    try {
      return await CarrinhoPercursoAgrupamentoConsultaRepository().select(
        queryBuilder ?? QueryBuilder(),
      );
    } catch (e) {
      throw Exception('Erro ao consultar agrupamentos: $e');
    }
  }

  Future<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel?> carrinhoPercurso(
    String itemCarrinhoPercurso,
  ) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodCarrinhoPercurso', codCarrinhoPercurso)
          .equals('ItemCarrinhoPercurso', itemCarrinhoPercurso);

      final result = await carrinhoPercursoAgrupamentoConsultaRepository
          .select(queryBuilder);

      if (result.isEmpty) return null;
      return result.first;
    } catch (e) {
      throw Exception('Erro ao buscar carrinho percurso: $e');
    }
  }

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>>
      carrinhosPercurso(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupador,
  ) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', carrinhoAgrupador.codEmpresa)
          .equals('CodCarrinhoPercurso', carrinhoAgrupador.codCarrinhoPercurso)
          .equals('Origem', carrinhoAgrupador.origem)
          .notEquals('CodCarrinho', carrinhoAgrupador.codCarrinho)
          .notEquals('Situacao', ExpedicaoSituacaoModel.cancelada);

      final result = await carrinhoPercursoAgrupamentoConsultaRepository
          .select(queryBuilder);
      return result;
    } catch (e) {
      throw Exception('Erro ao buscar carrinhos percurso para agrupamento: $e');
    }
  }

  Future<void> agruparCarrinho(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupador,
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupar,
  ) async {
    try {
      final agrupado = ExpedicaoCarrinhoPercursoAgrupamentoModel(
        codEmpresa: carrinhoAgrupar.codEmpresa,
        codCarrinhoPercurso: carrinhoAgrupar.codCarrinhoPercurso,
        item: '00000',
        origem: carrinhoAgrupar.origem,
        itemCarrinhoPercurso: carrinhoAgrupar.itemCarrinhoPercurso,
        situacao: ExpedicaoSituacaoModel.agrupado,
        codCarrinhoAgrupador: carrinhoAgrupador.codCarrinho,
        dataLancamento: DateTime.now(),
        horaLancamento: DateTime.now().toIso8601String().substring(11, 19),
        codUsuarioLancamento: _processo.codUsuario,
        nomeUsuarioLancamento: _processo.nomeUsuario,
      );

      final carrinhoQueryBuilder = QueryBuilder()
          .equals('CodEmpresa', carrinhoAgrupar.codEmpresa)
          .equals('CodCarrinho', carrinhoAgrupar.codCarrinho);

      final carrinho = await carrinhoRepository.select(carrinhoQueryBuilder);

      if (carrinho.isEmpty) {
        throw AppErrorAlert('Carrinho não encontrado');
      }

      final newCarrinho = carrinho.first.copyWith(
        situacao: ExpedicaoCarrinhoSituacaoModel.liberado,
      );

      final percursoEstagioQueryBuilder = QueryBuilder()
          .equals('CodEmpresa', carrinhoAgrupar.codEmpresa)
          .equals('CodCarrinhoPercurso', carrinhoAgrupar.codCarrinhoPercurso)
          .equals('Item', carrinhoAgrupar.itemCarrinhoPercurso);

      final percursoEstagioModel = await carrinhoPercursoEstagioRepository
          .select(percursoEstagioQueryBuilder);

      if (percursoEstagioModel.isEmpty) {
        throw AppErrorAlert('Percurso estágio não encontrado');
      }

      final percursoEstagio = percursoEstagioModel.first.copyWith(
        situacao: ExpedicaoSituacaoModel.agrupado,
      );

      await carrinhoRepository.update(newCarrinho);
      await carrinhoPercursoEstagioRepository.update(percursoEstagio);
      await carrinhoPercursoAgrupamentoRepository.insert(agrupado);
    } catch (e) {
      if (e is AppErrorAlert) rethrow;
      throw Exception('Erro ao agrupar carrinho: $e');
    }
  }

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>>
      agruparTodosCarrinho(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupador,
  ) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', carrinhoAgrupador.codEmpresa)
          .equals('CodCarrinhoPercurso', carrinhoAgrupador.codCarrinhoPercurso)
          .equals('Origem', carrinhoAgrupador.origem)
          .notEquals('CodCarrinho', carrinhoAgrupador.codCarrinho)
          .equals('CarrinhoAgrupador', 'N')
          .equals('Situacao', ExpedicaoSituacaoModel.conferido);

      final carrinhoPercursoAgrupamentoConsulta =
          await carrinhoPercursoAgrupamentoConsultaRepository
              .select(queryBuilder);

      if (carrinhoPercursoAgrupamentoConsulta.isEmpty) {
        throw AppErrorAlert('Não há carrinhos para agrupar');
      }

      for (final carrinhoAgrupar in carrinhoPercursoAgrupamentoConsulta) {
        await agruparCarrinho(carrinhoAgrupador, carrinhoAgrupar);
      }

      final newQueryBuilder = QueryBuilder()
          .equals('CodEmpresa', carrinhoAgrupador.codEmpresa)
          .equals('CodCarrinhoPercurso', carrinhoAgrupador.codCarrinhoPercurso)
          .equals('Origem', carrinhoAgrupador.origem)
          .notEquals('CodCarrinho', carrinhoAgrupador.codCarrinho)
          .equals('Situacao', ExpedicaoSituacaoModel.agrupado)
          .equals('CodCarrinhoAgrupador', carrinhoAgrupador.codCarrinho);

      return await carrinhoPercursoAgrupamentoConsultaRepository
          .select(newQueryBuilder);
    } catch (e) {
      if (e is AppErrorAlert) rethrow;
      throw Exception('Erro ao agrupar todos os carrinhos: $e');
    }
  }

  Future<void> cancelarAgrupamento(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupado,
  ) async {
    try {
      final carrinhoQueryBuilder = QueryBuilder()
          .equals('CodEmpresa', carrinhoAgrupado.codEmpresa)
          .equals('CodCarrinho', carrinhoAgrupado.codCarrinho);

      final carrinhos = await carrinhoRepository.select(carrinhoQueryBuilder);

      if (carrinhos.isEmpty) {
        throw AppErrorAlert('Carrinho não encontrado');
      }

      if (carrinhos.first.situacao != ExpedicaoCarrinhoSituacaoModel.liberado) {
        throw AppErrorAlert(
          'Carrinho não removido',
          details:
              'Carrinho não está liberado para cancelamento!. Situacao: ${carrinhos.first.situacao}',
        );
      }

      final newCarrinho = carrinhos.first.copyWith(
        situacao: ExpedicaoCarrinhoSituacaoModel.conferido,
      );

      final agrupadosParams = '''
        CodEmpresa = ${carrinhoAgrupado.codEmpresa}
          AND CodCarrinhoPercurso = ${carrinhoAgrupado.codCarrinhoPercurso}
          AND Item = '${carrinhoAgrupado.itemAgrupamento}' ''';

      final agrupados =
          await carrinhoPercursoAgrupamentoRepository.select(agrupadosParams);

      if (agrupados.isEmpty) {
        throw AppErrorAlert('Carrinho não encontrado');
      }

      final carrinhosPercursoEstagioQueryBuilder = QueryBuilder()
          .equals('CodEmpresa', carrinhoAgrupado.codEmpresa)
          .equals('CodCarrinhoPercurso', carrinhoAgrupado.codCarrinhoPercurso)
          .equals('Item', carrinhoAgrupado.itemCarrinhoPercurso);

      final carrinhosPercursoEstagio = await carrinhoPercursoEstagioRepository
          .select(carrinhosPercursoEstagioQueryBuilder);

      if (carrinhosPercursoEstagio.isEmpty) {
        throw AppErrorAlert('Carrinho percurso estágio não encontrado');
      }

      final percursoEstagio = carrinhosPercursoEstagio.first.copyWith(
        situacao: ExpedicaoSituacaoModel.conferido,
      );

      final agrupadoCancelar = agrupados.first.copyWith(
        situacao: ExpedicaoSituacaoModel.cancelada,
      );

      final cancelamento = ExpedicaoCancelamentoModel(
        codEmpresa: agrupadoCancelar.codEmpresa,
        codCancelamento: 0,
        origem: ExpedicaoOrigemModel.agrupado,
        codOrigem: agrupadoCancelar.codCarrinhoPercurso,
        itemOrigem: agrupadoCancelar.item,
        dataCancelamento: DateTime.now(),
        horaCancelamento: DateTime.now().toIso8601String().substring(11, 19),
        codUsuarioCancelamento: _processo.codUsuario,
        nomeUsuarioCancelamento: _processo.nomeUsuario,
      );

      await carrinhoPercursoEstagioRepository.update(percursoEstagio);
      await carrinhoPercursoAgrupamentoRepository.update(agrupadoCancelar);
      await cancelamentoRepository.insert(cancelamento);
      await carrinhoRepository.update(newCarrinho);
    } catch (e) {
      if (e is AppErrorAlert) rethrow;
      throw Exception('Erro ao cancelar agrupamento: $e');
    }
  }

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>>
      cancelarTodosAgrupamento(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupador,
  ) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', carrinhoAgrupador.codEmpresa)
          .equals('CodCarrinhoPercurso', carrinhoAgrupador.codCarrinhoPercurso)
          .equals('Origem', carrinhoAgrupador.origem)
          .notEquals('CodCarrinho', carrinhoAgrupador.codCarrinho)
          .equals('Situacao', ExpedicaoSituacaoModel.agrupado)
          .equals('CodCarrinhoAgrupador', carrinhoAgrupador.codCarrinho);

      final carrinhoPercursoAgrupamentoConsulta =
          await carrinhoPercursoAgrupamentoConsultaRepository
              .select(queryBuilder);

      if (carrinhoPercursoAgrupamentoConsulta.isEmpty) {
        throw AppErrorAlert('Não há carrinhos para cancelar agrupamento');
      }

      for (final carrinhoAgrupar in carrinhoPercursoAgrupamentoConsulta) {
        await cancelarAgrupamento(carrinhoAgrupar);
      }

      final basicQueryBuilder = QueryBuilder()
          .equals('CodEmpresa', carrinhoAgrupador.codEmpresa)
          .equals('CodCarrinhoPercurso', carrinhoAgrupador.codCarrinhoPercurso)
          .equals('Origem', carrinhoAgrupador.origem)
          .notEquals('CodCarrinho', carrinhoAgrupador.codCarrinho)
          .equals('Situacao', ExpedicaoSituacaoModel.conferido);

      return await carrinhoPercursoAgrupamentoConsultaRepository
          .select(basicQueryBuilder);
    } catch (e) {
      if (e is AppErrorAlert) rethrow;
      throw Exception('Erro ao cancelar todos os agrupamentos: $e');
    }
  }
}
