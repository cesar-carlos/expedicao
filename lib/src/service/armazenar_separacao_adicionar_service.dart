import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/repository/expedicao_armazenar/armazenar_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_consulta_separacao_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_armazenar_item/armazenar_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_separado_item_consulta_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_armazenar_item.dart';
import 'package:app_expedicao/src/model/expedicao_armazenar.dart';

class ArmazenarSeparacaoAdicionarService {
  final ExpedicaoCarrinhoPercursoModel carrinhoPercurso;
  final _processoExecutavel = Get.find<ProcessoExecutavelModel>();

  ArmazenarSeparacaoAdicionarService(this.carrinhoPercurso);

  Future<void> execute() async {
    try {
      final itensSeparacaoConsulta = await _findItensSeparado();
      final armazenar = _createArmazenar(itensSeparacaoConsulta.first);
      final result = await ArmazenarRepository().insert(armazenar);

      if (result.isEmpty) throw AppError('Erro ao armazenar');

      final newItens =
          _createItensArmazenar(result.first, itensSeparacaoConsulta);

      await ArmazenarItemRepository().insertAll(newItens);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ExpedicaoSeparadoItemConsultaModel>> _findItensSeparado() async {
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

  ExpedicaoArmazenar _createArmazenar(
    ExpedicaoSeparadoItemConsultaModel item,
  ) {
    return ExpedicaoArmazenar(
      codEmpresa: item.codEmpresa,
      codArmazenar: 0,
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

  List<ExpedicaoArmazenarItem> _createItensArmazenar(
    ExpedicaoArmazenar armazenar,
    List<ExpedicaoSeparadoItemConsultaModel> itens,
  ) {
    final newItens = <ExpedicaoArmazenarItem>[];

    for (var el in itens) {
      newItens.add(ExpedicaoArmazenarItem(
        codEmpresa: armazenar.codEmpresa,
        codArmazenar: armazenar.codArmazenar,
        item: '00000',
        codProduto: el.codProduto,
        nomeProduto: el.nomeProduto,
        codUnidadeMedida: el.codUnidadeMedida,
        codProdutoEndereco: el.endereco.toString(),
        codigoBarras: el.codigoBarras,
        quantidade: el.quantidadeSeparacao,
      ));
    }

    return newItens;
  }
}
