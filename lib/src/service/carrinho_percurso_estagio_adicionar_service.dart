import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_estagio/expedicao_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/model/expedicao_estagio_model.dart';

class CarrinhoPercursoEstagioAdicionarService {
  final _processo = Get.find<ProcessoExecutavelModel>();

  final ExpedicaoCarrinhoModel carrinho;
  final ExpedicaoCarrinhoPercursoModel carrinhoPercurso;

  CarrinhoPercursoEstagioAdicionarService({
    required this.carrinho,
    required this.carrinhoPercurso,
  });

  Future<ExpedicaoPercursoEstagioModel?> execute() async {
    final creatEstagio = await _createPercursoEstagio();
    await CarrinhoRepository().update(carrinho);

    final newEstagio =
        await CarrinhoPercursoEstagioRepository().insert(creatEstagio);

    if (newEstagio.isNotEmpty) {
      return newEstagio.first;
    }

    return null;
  }

  Future<ExpedicaoPercursoEstagioModel> _createPercursoEstagio() async {
    final percurso = await _findcodPercursoEstagio();
    return ExpedicaoPercursoEstagioModel(
      codEmpresa: carrinhoPercurso.codEmpresa,
      codCarrinhoPercurso: carrinhoPercurso.codCarrinhoPercurso,
      item: '',
      codPercursoEstagio: percurso?.codPercursoEstagio ?? 0,
      codCarrinho: carrinho.codCarrinho,
      situacao: ExpedicaoSituacaoModel.emAndamento,
      dataInicio: DateTime.now(),
      horaInicio: DateTime.now().toString().substring(11, 19),
      codUsuarioInicio: _processo.codUsuario,
      nomeUsuarioInicio: _processo.nomeUsuario,
    );
  }

  Future<ExpedicaoEstagioModel?> _findcodPercursoEstagio() async {
    final repository = ExpedicaoEstagioRepository();
    final params = ''' Origem LIKE '${_processo.origem}'  AND Ativo = 'S' ''';

    final estagios = await repository.select(params);
    if (estagios.isEmpty) return null;
    estagios.sort((a, b) => a.sequencia.compareTo(b.sequencia));
    return estagios.first;
  }
}
