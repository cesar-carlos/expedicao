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
    try {
      final creatEstagio = await _createPercursoEstagio();
      await carrinhoRepository.update(carrinho);

      final newEstagio =
          await carrinhoPercursoEstagioRepository.insert(creatEstagio);

      if (newEstagio.isNotEmpty) {
        return newEstagio.first;
      }

      return null;
    } catch (e) {
      throw Exception('Erro ao adicionar carrinho percurso estágio: $e');
    }
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
        codPercursoEstagio: percurso?.codPercursoEstagio ?? 0,
        codCarrinho: carrinho.codCarrinho,
        situacao: situacao,
        dataInicio: DateTime.now(),
        horaInicio: DateTime.now().toIso8601String().substring(11, 19),
        codUsuarioInicio: _processo.codUsuario,
        nomeUsuarioInicio: _processo.nomeUsuario,
      );
    } catch (e) {
      throw Exception('Erro ao criar percurso estágio: $e');
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

  Future<ExpedicaoEstagioModel?> _findcodPercursoEstagio() async {
    try {
      final queryBuilder =
          QueryBuilder().like('Origem', _processo.origem).equals('Ativo', 'S');

      final estagios = await expedicaoEstagioRepository.select(queryBuilder);

      if (estagios.isEmpty) return null;

      estagios.sort((a, b) => a.sequencia.compareTo(b.sequencia));
      return estagios.first;
    } catch (e) {
      throw Exception('Erro ao buscar percurso estágio: $e');
    }
  }
}
