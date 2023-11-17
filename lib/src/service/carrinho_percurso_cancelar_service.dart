import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/repository/expedicao_cancelamento/cancelamento_repository.dart';
import 'package:app_expedicao/src/repository/sequencia_registro/sequencia_registro_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/repository/sequencia_registro/sequencia_tabelas.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_model.dart';
import 'package:app_expedicao/src/model/expedicao_cancelamento_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';

class CarrinhoPercursoCancelarService {
  final ExpedicaoCarrinhoModel carrinho;
  final ExpedicaoPercursoEstagioModel percursoEstagio;
  final ProcessoExecutavelModel processo;

  CarrinhoPercursoCancelarService({
    required this.carrinho,
    required this.percursoEstagio,
    required this.processo,
  });

  Future<void> execute() async {
    final newCarrinho = carrinho.copyWith(situacao: 'LI');
    final newPercursoEstagio = percursoEstagio.copyWith(situacao: 'CA');
    final newCancelamento = await _createCancelamento();

    //await CarrinhoRepository().update(newCarrinho);
    //await CarrinhoPercursoEstagioRepository().update(newPercursoEstagio);
    //await CancelamentoRepository().insert(newCancelamento);
  }

  Future<ExpedicaoCancelamentoModel> _createCancelamento() async {
    final sequencia = await SequenciaRegistroRepository()
        .select(SequenciaTabelas.expedicaoCancelamento);

    return ExpedicaoCancelamentoModel(
      codEmpresa: percursoEstagio.codEmpresa,
      codCancelamento: sequencia.first.valor,
      origem: 'CP',
      codOrigem: percursoEstagio.codCarrinhoPercurso,
      itemOrigem: percursoEstagio.codCarrinho.toString(),
      codMotivoCancelamento: 1,
      dataCancelamento: DateTime.now(),
      horaCancelamento: DateTime.now().toString().substring(11, 19),
      codUsuarioCancelamento: processo.codUsuario,
      nomeUsuarioCancelamento: processo.nomeUsuario,
      observacaoCancelamento: null,
    );
  }
}
