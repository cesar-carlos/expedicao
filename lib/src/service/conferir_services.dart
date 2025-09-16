import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/service/expedicao_percurso_atualizar_service.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_estagio/expedicao_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_repository.dart';
import 'package:app_expedicao/src/service/expedicao_percurso_adicionar_service.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';

class ConferirServices {
  final repositoryConferir = ConferirRepository();
  final repositoryEstagio = ExpedicaoEstagioRepository();
  final origem = ExpedicaoOrigemModel.conferencia;
  final ExpedicaoConferirModel conferir;

  ConferirServices(this.conferir);

  Future<void> iniciar() async {
    try {
      final newConferir = conferir.copyWith(
        situacao: ExpedicaoSituacaoModel.emConverencia,
      );

      final existsPercurso = await _existsPercurso();
      if (!existsPercurso) {
        await _iniciarPercurso();
      } else {
        await _atualizarPercurso();
      }

      await repositoryConferir.update(newConferir);
    } catch (e) {
      throw Exception('Erro ao iniciar conferência: $e');
    }
  }

  Future<void> pausa() async {
    throw UnimplementedError('Funcionalidade de pausa ainda não implementada');
  }

  Future<void> retomar() async {
    throw UnimplementedError(
        'Funcionalidade de retomada ainda não implementada');
  }

  Future<void> finalizar() async {
    throw UnimplementedError(
        'Funcionalidade de finalização ainda não implementada');
  }

  static Future<void> atualizar(ExpedicaoConferirModel conferir) async {
    try {
      await ConferirRepository().update(conferir);
    } catch (e) {
      throw Exception('Erro ao atualizar conferência: $e');
    }
  }

  Future<bool> _existsPercurso() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', conferir.codEmpresa)
          .equals('Origem', conferir.origem)
          .equals('CodOrigem', conferir.codOrigem)
          .notEquals('Situacao', ExpedicaoSituacaoModel.cancelada);

      final carrinhoPercurso =
          await CarrinhoPercursoRepository().select(queryBuilder);
      return carrinhoPercurso.isNotEmpty;
    } catch (e) {
      throw Exception('Erro ao verificar existência de percurso: $e');
    }
  }

  Future<void> _iniciarPercurso() async {
    try {
      await ExpedicaoPercursoAdicionarService(
        codEmpresa: conferir.codEmpresa,
        origem: origem,
        codOrigem: conferir.codConferir,
        situacao: ExpedicaoSituacaoModel.emConverencia,
      ).execute();
    } catch (e) {
      throw Exception('Erro ao iniciar percurso: $e');
    }
  }

  Future<void> _atualizarPercurso() async {
    try {
      await ExpedicaoPercursoAtualizarService(
        codEmpresa: conferir.codEmpresa,
        origem: conferir.origem,
        codOrigem: conferir.codOrigem,
        situacao: ExpedicaoSituacaoModel.emConverencia,
      ).execute();
    } catch (e) {
      throw Exception('Erro ao atualizar percurso: $e');
    }
  }
}
