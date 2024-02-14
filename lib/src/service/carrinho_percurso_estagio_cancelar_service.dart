import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_model.dart';
import 'package:app_expedicao/src/repository/expedicao_estagio/expedicao_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_cancelamento/cancelamento_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/model/expedicao_cancelamento_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/model/expedicao_estagio_model.dart';

class CarrinhoPercursoEstagioCancelarService {
  final _processo = Get.find<ProcessoExecutavelModel>();

  final ExpedicaoCarrinhoModel carrinho;
  final ExpedicaoCarrinhoPercursoEstagioModel percursoEstagio;

  CarrinhoPercursoEstagioCancelarService({
    required this.carrinho,
    required this.percursoEstagio,
  });

  Future<void> execute() async {
    final newPercursoEstagio = percursoEstagio.copyWith(
      situacao: ExpedicaoSituacaoModel.cancelada,
    );

    final newCancelamento = await _createCancelamento();

    await CancelamentoRepository().insert(newCancelamento);
    await CarrinhoPercursoEstagioRepository().update(newPercursoEstagio);
    await CarrinhoRepository().update(carrinho);
  }

  Future<ExpedicaoCancelamentoModel> _createCancelamento() async {
    return ExpedicaoCancelamentoModel(
      codEmpresa: percursoEstagio.codEmpresa,
      codCancelamento: 0,
      origem: ExpedicaoOrigemModel.carrinhoPercurso,
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

  // ignore: unused_element
  Future<ExpedicaoEstagioModel?> _findcodPercursoEstagio() async {
    final repository = ExpedicaoEstagioRepository();
    final params = ''' Origem LIKE '${_processo.origem}' AND Ativo = 'S' ''';

    final estagios = await repository.select(params);
    if (estagios.isEmpty) return null;
    estagios.sort((a, b) => a.sequencia.compareTo(b.sequencia));
    return estagios.first;
  }
}
