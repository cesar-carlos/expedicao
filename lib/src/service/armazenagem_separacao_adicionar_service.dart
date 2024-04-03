import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/repository/expedicao_armazenagem/armazenagem_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_consulta_separacao_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_armazenagem_item/armazenagem_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_separado_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_armazenagem_item.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_armazenagem.dart';

class ArmazenarSeparacaoAdicionarService {
  final ExpedicaoCarrinhoPercursoModel carrinhoPercurso;
  final _processoExecutavel = Get.find<ProcessoExecutavelModel>();

  ArmazenarSeparacaoAdicionarService(this.carrinhoPercurso);

  Future<void> execute() async {
    try {
      final itensSeparacaoConsulta = await _findSeparado();
      final armazenar = _createArmazenar(itensSeparacaoConsulta.first);
      final result = await ArmazenagemRepository().insert(armazenar);

      final newItens = _createItensArmazenar(
        result.first,
        itensSeparacaoConsulta,
      );

      await ArmazenagemItemRepository().insertAll(newItens);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ExpedicaoSeparadoItemConsultaModel>> _findSeparado() async {
    try {
      final repository = ConferirItemConsultaSeparacaoRepository();

      final params = '''
        CodEmpresa = ${carrinhoPercurso.codEmpresa}
      AND Origem = '${carrinhoPercurso.origem}'
      AND CodSepararEstoque = ${carrinhoPercurso.codOrigem}
      AND Situacao = '${ExpedicaoSituacaoModel.separado}' ''';

      final itens = await repository.select(params);
      if (itens.isEmpty) throw AppError('Nenhum item encontrado');

      return itens;
    } catch (e) {
      rethrow;
    }
  }

  ExpedicaoArmazenagem _createArmazenar(
    ExpedicaoSeparadoItemConsultaModel item,
  ) {
    return ExpedicaoArmazenagem(
      codEmpresa: item.codEmpresa,
      codArmazenagem: 0,
      numeroDocumento: null,
      situacao: ExpedicaoSituacaoModel.aguardando,
      origem: ExpedicaoOrigemModel.separacao,
      codOrigem: item.codSepararEstoque,
      codPrioridade: item.codPrioridade,
      dataLancamento: DateTime.now(),
      horaLancamento: DateTime.now().toString().substring(11, 19),
      codUsuarioLancamento: _processoExecutavel.codUsuario,
      nomeUsuarioLancamento: _processoExecutavel.nomeUsuario,
      estacaoLancamento: _processoExecutavel.nomeComputador,
      observacao: item.observacao,
    );
  }

  List<ExpedicaoArmazenagemItem> _createItensArmazenar(
    ExpedicaoArmazenagem armazenar,
    List<ExpedicaoSeparadoItemConsultaModel> itens,
  ) {
    final newItens = <ExpedicaoArmazenagemItem>[];

    for (var el in itens) {
      newItens.add(ExpedicaoArmazenagemItem(
        codEmpresa: armazenar.codEmpresa,
        codArmazenagem: armazenar.codArmazenagem,
        item: '00000',
        codCarrinhoPercurso: el.codCarrinhoPercurso,
        itemCarrinhoPercurso: el.itemCarrinhoPercurso,
        codLocalArmazenagem: el.codLocalArmazenagem,
        codSetorEstoque: el.codSetorEstoque,
        codProduto: el.codProduto,
        nomeProduto: el.nomeProduto,
        codUnidadeMedida: el.codUnidadeMedida,
        codigoBarras: el.codigoBarras,
        codProdutoEndereco: el.endereco.toString(),
        quantidade: el.quantidadeSeparacao,
        quantidadeArmazenada: 0.00,
      ));
    }

    return newItens;
  }
}
