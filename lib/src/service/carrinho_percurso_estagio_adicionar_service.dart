import 'socket_mutation_action.dart';

import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_estagio/expedicao_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/model/expedicao_estagio_model.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class CarrinhoPercursoEstagioAdicionarService {
  final _processo = Get.find<ProcessoExecutavelModel>();

  final ExpedicaoCarrinhoModel carrinho;
  final carrinhoRepository = CarrinhoRepository();
  final ExpedicaoCarrinhoPercursoModel carrinhoPercurso;
  final carrinhoPercursoEstagioRepository = CarrinhoPercursoEstagioRepository();
  final expedicaoEstagioRepository = ExpedicaoEstagioRepository();

  CarrinhoPercursoEstagioAdicionarService({
    required this.carrinho,
    required this.carrinhoPercurso,
  });

  Future<ExpedicaoCarrinhoPercursoEstagioModel?> execute() async {
    return runSocketMutation(() async {
      try {
        final creatEstagio = await _createPercursoEstagio();
        await carrinhoRepository.update(carrinho);

        final newEstagio = await carrinhoPercursoEstagioRepository.insert(
          creatEstagio,
        );

        if (newEstagio.isNotEmpty) {
          return newEstagio.first;
        }

        return null;
      } catch (e) {
        throw AppError.fromUnknown(e);
      }
    });
  }

  Future<ExpedicaoCarrinhoPercursoEstagioModel> _createPercursoEstagio() async {
    try {
      final percurso = await _findcodPercursoEstagio();
      final origem = _processo.origem;
      final situacao = _getSituacaoByOrigem(origem);

      return ExpedicaoCarrinhoPercursoEstagioModel(
        codEmpresa: carrinhoPercurso.codEmpresa,
        codCarrinhoPercurso: carrinhoPercurso.codCarrinhoPercurso,
        item: '',
        origem: _processo.origem,
        codOrigem: _processo.codOrigem,
        codPercursoEstagio: percurso.codPercursoEstagio,
        codCarrinho: carrinho.codCarrinho,
        situacao: situacao,
        dataInicio: DateTime.now(),
        horaInicio: DateTime.now().toIso8601String().substring(11, 19),
        codUsuarioInicio: _processo.codUsuario,
        nomeUsuarioInicio: _processo.nomeUsuario,
      );
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  String _getSituacaoByOrigem(String origem) {
    switch (origem) {
      case ExpedicaoOrigemModel.separacao:
        return ExpedicaoSituacaoModel.separando;
      case ExpedicaoOrigemModel.conferencia:
        return ExpedicaoSituacaoModel.conferindo;
      default:
        return ExpedicaoSituacaoModel.conferindo;
    }
  }

  Future<ExpedicaoEstagioModel> _findcodPercursoEstagio() async {
    final origem = _processo.origem;

    try {
      final queryBuilder = QueryBuilder()
          .equals('Origem', origem)
          .equals('Ativo', 'S')
          .orderByAsc('Sequencia')
          .orderByAsc('CodPercursoEstagio')
          .paginate(limit: 1);

      final estagios = await expedicaoEstagioRepository.select(queryBuilder);

      if (estagios.isEmpty || estagios.first.codPercursoEstagio <= 0) {
        throw AppError(
          'Nenhum estágio ativo encontrado para a origem $origem.',
        );
      }
      return estagios.first;
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }
}
