import 'package:get/get.dart';

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

  Future<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel?> carrinhoPercurso(
    String itemCarrinhoPercurso,
  ) async {
    final params = '''
        CodEmpresa = $codEmpresa
          AND CodCarrinhoPercurso = '$codCarrinhoPercurso'
          AND ItemCarrinhoPercurso = $itemCarrinhoPercurso  ''';

    final result =
        await CarrinhoPercursoAgrupamentoConsultaRepository().select(params);

    if (result.isEmpty) return null;
    return result.first;
  }

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>>
      carrinhosPercurso() async {
    final params = '''
        CodEmpresa = $codEmpresa
          AND CodCarrinhoPercurso = '$codCarrinhoPercurso' ''';

    final result =
        await CarrinhoPercursoAgrupamentoConsultaRepository().select(params);

    return result;
  }

  Future<void> agruparCarrinhoPercurso(
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
        AND CodCarrinho = ${carrinhoAgrupar.codCarrinho}''',
    );

    if (_carrinho.isEmpty) throw Exception('Carrinho não encontrado');

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
      throw Exception('Percurso estagio não encontrado');

    final _percursoEstagio = _percursoEstagioModel.first
        .copyWith(situacao: ExpedicaoSituacaoModel.agrupado);

    //
    await _carrinhoPercursoEstagioRepository.update(_percursoEstagio);
    await _carrinhoPercursoAgrupamentoRepository.insert(_agrupado);
    await _carrinhoRepository.update(_newCarrinho);
  }

  Future<void> cancelarAgrupamento(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupado,
  ) async {
    final _carrinhos = await _carrinhoRepository.select(
      '''CodEmpresa = ${carrinhoAgrupado.codEmpresa} 
        AND CodCarrinho = ${carrinhoAgrupado.codCarrinho}''',
    );

    if (_carrinhos.isEmpty) throw Exception('Carrinho não encontrado');
    if (_carrinhos.first.situacao != ExpedicaoCarrinhoSituacaoModel.liberado)
      throw Exception('Carrinho não está liberado para cancelamento!');

    final _newCarrinho = _carrinhos.first.copyWith(
      situacao: ExpedicaoCarrinhoSituacaoModel.conferido,
    );

    final agrupados = await _carrinhoPercursoAgrupamentoRepository.select('''
        CodEmpresa = ${carrinhoAgrupado.codEmpresa}
          AND CodCarrinhoPercurso = ${carrinhoAgrupado.codCarrinhoPercurso}
          AND Item = '${carrinhoAgrupado.itemAgrupamento}' ''');

    if (agrupados.isEmpty) throw Exception('Carrinho agrupado não encontrado');

    final _carrinhosPercursoEstaio =
        await _carrinhoPercursoEstagioRepository.select(
      '''CodEmpresa = ${carrinhoAgrupado.codEmpresa}
        AND CodCarrinhoPercurso = ${carrinhoAgrupado.codCarrinhoPercurso}
        AND Item = '${carrinhoAgrupado.itemCarrinhoPercurso}' ''',
    );

    if (_carrinhosPercursoEstaio.isEmpty)
      throw Exception('Carrinho percurso estagio não encontrado');

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
}
