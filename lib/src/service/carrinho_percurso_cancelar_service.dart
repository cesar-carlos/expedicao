import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_model.dart';
import 'package:app_expedicao/src/repository/sequencia_registro/sequencia_tabelas.dart';
import 'package:app_expedicao/src/repository/expedicao_cancelamento/cancelamento_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/repository/sequencia_registro/sequencia_registro_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/model/expedicao_cancelamento_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';

class CarrinhoPercursoCancelarService {
  final _processo = Get.find<ProcessoExecutavelModel>();

  final ExpedicaoCarrinhoModel carrinho;
  final ExpedicaoPercursoEstagioModel percursoEstagio;

  CarrinhoPercursoCancelarService({
    required this.carrinho,
    required this.percursoEstagio,
  });

  Future<void> execute() async {
    final separacaoItens = await _findSeparacaoItem();
    final newCarrinho = carrinho.copyWith(situacao: 'LI');
    final newPercursoEstagio = percursoEstagio.copyWith(situacao: 'CA');
    final newCancelamento = await _createCancelamento();

    final newItens = separacaoItens.map((el) {
      return el.copyWith(situacao: 'CA');
    }).toList();

    await CancelamentoRepository().insert(newCancelamento);
    await SeparacaoItemRepository().updateAll(newItens);
    await CarrinhoPercursoEstagioRepository().update(newPercursoEstagio);
    await CarrinhoRepository().update(newCarrinho);
  }

  Future<List<ExpedicaoSeparacaoItemModel>> _findSeparacaoItem() async {
    final params = ''' 
          CodEmpresa = ${percursoEstagio.codEmpresa} 
      AND CodCarrinhoPercurso = ${percursoEstagio.codCarrinhoPercurso} 
      AND ItemCarrinhoPercurso = ${percursoEstagio.item} 
      
    ''';

    return await SeparacaoItemRepository().select(params);
  }

  Future<ExpedicaoCancelamentoModel> _createCancelamento() async {
    final sequencia = await SequenciaRegistroRepository()
        .select(SequenciaTabelas.expedicaoCancelamento);

    return ExpedicaoCancelamentoModel(
      codEmpresa: percursoEstagio.codEmpresa,
      codCancelamento: sequencia.first.valor,
      origem: 'CP',
      codOrigem: percursoEstagio.codCarrinhoPercurso,
      itemOrigem: percursoEstagio.item,
      codMotivoCancelamento: 1,
      dataCancelamento: DateTime.now(),
      horaCancelamento: DateTime.now().toString().substring(11, 19),
      codUsuarioCancelamento: _processo.codUsuario,
      nomeUsuarioCancelamento: _processo.nomeUsuario,
      observacaoCancelamento: null,
    );
  }
}
