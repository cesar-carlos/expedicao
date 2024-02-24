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
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';

class CarrinhoPercursoEstagioAgruparService {
  final int codEmpresa;
  final int codCarrinhoPercurso;

  final _processo = Get.find<ProcessoExecutavelModel>();

  final _carrinhoPercursoAgrupamentoRepository =
      CarrinhoPercursoAgrupamentoRepository();

  final _cancelamentoEventRepository = CancelamentoRepository();

  final _carrinhoPercursoEstagioRepository =
      CarrinhoPercursoEstagioRepository();

  final _carrinhoRepository = CarrinhoRepository();

  CarrinhoPercursoEstagioAgruparService({
    required this.codEmpresa,
    required this.codCarrinhoPercurso,
  });

  static Future<List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>>
      consulta([String params = '']) async {
    return await CarrinhoPercursoAgrupamentoConsultaRepository().select(params);
  }

  Future<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel?> carrinhoPercurso(
    String itemCarrinhoPercurso,
  ) async {
    final params = '''
        CodEmpresa = $codEmpresa
          AND CodCarrinhoPercurso = '$codCarrinhoPercurso'
          AND ItemCarrinhoPercurso = $itemCarrinhoPercurso  ''';

    final result = await CarrinhoPercursoAgrupamentoConsultaRepository().select(
      params,
    );

    if (result.isEmpty) return null;
    return result.first;
  }

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>>
      carrinhosPercurso(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupador,
  ) async {
    final params = '''
        CodEmpresa = ${carrinhoAgrupador.codEmpresa}
          AND CodCarrinhoPercurso = ${carrinhoAgrupador.codCarrinhoPercurso}
          AND Origem = '${carrinhoAgrupador.origem}' 
          AND CodCarrinho <> ${carrinhoAgrupador.codCarrinho} 
          AND Situacao <> '${ExpedicaoSituacaoModel.cancelada}' ''';

    final result =
        await CarrinhoPercursoAgrupamentoConsultaRepository().select(params);

    return result;
  }

  Future<void> agruparCarrinho(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupador,
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupar,
  ) async {
    final _agrupado = ExpedicaoCarrinhoPercursoAgrupamentoModel(
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

    final _carrinho = await _carrinhoRepository.select(
      '''CodEmpresa = ${carrinhoAgrupar.codEmpresa} 
          AND CodCarrinho = ${carrinhoAgrupar.codCarrinho} ''',
    );

    if (_carrinho.isEmpty) {
      throw AppErrorAlert('Carrinho não encontrado');
    }

    final _newCarrinho = _carrinho.first.copyWith(
      situacao: ExpedicaoCarrinhoSituacaoModel.liberado,
    );

    final _percursoEstagioModel =
        await _carrinhoPercursoEstagioRepository.select(
      '''CodEmpresa = ${carrinhoAgrupar.codEmpresa} 
          AND CodCarrinhoPercurso = ${carrinhoAgrupar.codCarrinhoPercurso} 
          AND item = '${carrinhoAgrupar.itemCarrinhoPercurso}' ''',
    );

    if (_percursoEstagioModel.isEmpty)
      throw AppErrorAlert('Percurso estagio não encontrado');

    final _percursoEstagio = _percursoEstagioModel.first.copyWith(
      situacao: ExpedicaoSituacaoModel.agrupado,
    );

    await _carrinhoRepository.update(_newCarrinho);
    await _carrinhoPercursoEstagioRepository.update(_percursoEstagio);
    await _carrinhoPercursoAgrupamentoRepository.insert(_agrupado);
  }

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>>
      agruparTodosCarrinho(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupador,
  ) async {
    final params = '''
        CodEmpresa = ${carrinhoAgrupador.codEmpresa}
          AND CodCarrinhoPercurso = ${carrinhoAgrupador.codCarrinhoPercurso}
          AND Origem = '${carrinhoAgrupador.origem}' 
          AND CodCarrinho <> ${carrinhoAgrupador.codCarrinho} 
          AND CarrinhoAgrupador = 'N' 
          AND Situacao = '${ExpedicaoSituacaoModel.conferido}' ''';

    final carrinhoPercursoAgrupamentoConsulta =
        await CarrinhoPercursoAgrupamentoConsultaRepository().select(params);

    if (carrinhoPercursoAgrupamentoConsulta.isEmpty)
      throw AppErrorAlert('Não há carrinhos para agrupar');

    for (final carrinhoAgrupar in carrinhoPercursoAgrupamentoConsulta) {
      await agruparCarrinho(carrinhoAgrupador, carrinhoAgrupar);
    }

    final newParams = '''
        CodEmpresa = ${carrinhoAgrupador.codEmpresa}
          AND CodCarrinhoPercurso = ${carrinhoAgrupador.codCarrinhoPercurso}
          AND Origem = '${carrinhoAgrupador.origem}' 
          AND CodCarrinho <> ${carrinhoAgrupador.codCarrinho} 
          AND Situacao = '${ExpedicaoSituacaoModel.agrupado}' 
          AND CodCarrinhoAgrupador = ${carrinhoAgrupador.codCarrinho} ''';

    return await CarrinhoPercursoAgrupamentoConsultaRepository()
        .select(newParams);
  }

  Future<void> cancelarAgrupamento(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupado,
  ) async {
    final _carrinhos = await _carrinhoRepository.select(
      '''CodEmpresa = ${carrinhoAgrupado.codEmpresa} 
          AND CodCarrinho = ${carrinhoAgrupado.codCarrinho} ''',
    );

    if (_carrinhos.isEmpty) {
      throw AppErrorAlert('Carrinho não encontrado');
    }

    if (_carrinhos.first.situacao != ExpedicaoCarrinhoSituacaoModel.liberado)
      throw AppErrorAlert(
        'Carrinho não removido',
        details:
            'Carrinho não está liberado para cancelamento!. Situacao: ${_carrinhos.first.situacao}',
      );

    final _newCarrinho = _carrinhos.first.copyWith(
      situacao: ExpedicaoCarrinhoSituacaoModel.conferido,
    );

    final agrupados = await _carrinhoPercursoAgrupamentoRepository.select('''
        CodEmpresa = ${carrinhoAgrupado.codEmpresa}
          AND CodCarrinhoPercurso = ${carrinhoAgrupado.codCarrinhoPercurso}
          AND Item = '${carrinhoAgrupado.itemAgrupamento}' ''');

    if (agrupados.isEmpty) {
      throw AppErrorAlert('Carrinho não encontrado');
    }

    final _carrinhosPercursoEstaio =
        await _carrinhoPercursoEstagioRepository.select(
      '''CodEmpresa = ${carrinhoAgrupado.codEmpresa}
          AND CodCarrinhoPercurso = ${carrinhoAgrupado.codCarrinhoPercurso}
          AND Item = '${carrinhoAgrupado.itemCarrinhoPercurso}' ''',
    );

    if (_carrinhosPercursoEstaio.isEmpty)
      throw AppErrorAlert('Carrinho percurso estagio não encontrado');

    final _percursoEstagio = _carrinhosPercursoEstaio.first.copyWith(
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

    await _carrinhoPercursoEstagioRepository.update(_percursoEstagio);
    await _carrinhoPercursoAgrupamentoRepository.update(agrupadoCancelar);
    await _cancelamentoEventRepository.insert(cancelamento);
    await _carrinhoRepository.update(_newCarrinho);
  }

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>>
      cancelarTodosAgrupamento(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupador,
  ) async {
    final params = '''
        CodEmpresa = ${carrinhoAgrupador.codEmpresa}
          AND CodCarrinhoPercurso = ${carrinhoAgrupador.codCarrinhoPercurso}
          AND Origem = '${carrinhoAgrupador.origem}' 
          AND CodCarrinho <> ${carrinhoAgrupador.codCarrinho} 
          AND Situacao = '${ExpedicaoSituacaoModel.agrupado}' 
          AND CodCarrinhoAgrupador = ${carrinhoAgrupador.codCarrinho} ''';

    final carrinhoPercursoAgrupamentoConsulta =
        await CarrinhoPercursoAgrupamentoConsultaRepository().select(params);

    if (carrinhoPercursoAgrupamentoConsulta.isEmpty)
      throw AppErrorAlert('Não há carrinhos para agrupar');

    for (final carrinhoAgrupar in carrinhoPercursoAgrupamentoConsulta) {
      await cancelarAgrupamento(carrinhoAgrupar);
    }

    final newParams = '''
        CodEmpresa = ${carrinhoAgrupador.codEmpresa}
          AND CodCarrinhoPercurso = ${carrinhoAgrupador.codCarrinhoPercurso}
          AND Origem = '${carrinhoAgrupador.origem}' 
          AND CodCarrinho <> ${carrinhoAgrupador.codCarrinho} 
          AND Situacao = '${ExpedicaoSituacaoModel.conferido}' 
          AND CodCarrinhoAgrupador IS NULL ''';

    return await CarrinhoPercursoAgrupamentoConsultaRepository()
        .select(newParams);
  }
}
