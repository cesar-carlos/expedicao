import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separar/separar_repository.dart';
import 'package:app_expedicao/src/service/expedicao_percurso_adicionar_service.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_model.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class SepararServices {
  final ExpedicaoSepararModel separar;
  final separacaoItemRepository = SeparacaoItemRepository();
  final carrinhoPercursoRepository = CarrinhoPercursoRepository();
  final separarRepository = SepararRepository();

  SepararServices(this.separar);

  Future<void> iniciar() async {
    try {
      final existsPercurso = await _existsPercurso();

      if (!existsPercurso) {
        await _iniciarPercurso();
      }

      final newSeparar = separar.copyWith(
        situacao: ExpedicaoSituacaoModel.separando,
      );

      await separarRepository.update(newSeparar);
    } catch (e) {
      throw Exception('Erro ao iniciar separação: $e');
    }
  }

  Future<List<ExpedicaoSeparacaoItemModel>> separacaoItem() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', separar.codEmpresa)
          .equals('CodSepararEstoque', separar.codSepararEstoque)
          .equals('Situacao', ExpedicaoItemSituacaoModel.separado);

      return await separacaoItemRepository.select(queryBuilder);
    } catch (e) {
      throw Exception('Erro ao buscar itens de separação: $e');
    }
  }

  Future<void> pausa() async {
    throw UnimplementedError('Método pausa ainda não implementado');
  }

  Future<void> retomar() async {
    throw UnimplementedError('Método retomar ainda não implementado');
  }

  Future<void> finalizar() async {
    throw UnimplementedError('Método finalizar ainda não implementado');
  }

  static Future<void> atualizar(ExpedicaoSepararModel separar) async {
    try {
      await SepararRepository().update(separar);
    } catch (e) {
      throw Exception('Erro ao atualizar separação: $e');
    }
  }

  Future<bool> _existsPercurso() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', separar.codEmpresa)
          .equals('Origem', ExpedicaoOrigemModel.separacao)
          .equals('CodOrigem', separar.codSepararEstoque)
          .notEquals('Situacao', ExpedicaoSituacaoModel.cancelada);

      final carrinhoPercurso =
          await carrinhoPercursoRepository.select(queryBuilder);
      return carrinhoPercurso.isNotEmpty;
    } catch (e) {
      throw Exception('Erro ao verificar percurso existente: $e');
    }
  }

  Future<void> _iniciarPercurso() async {
    try {
      await ExpedicaoPercursoAdicionarService(
        codEmpresa: separar.codEmpresa,
        origem: ExpedicaoOrigemModel.separacao,
        codOrigem: separar.codSepararEstoque,
        situacao: ExpedicaoSituacaoModel.emSeparacao,
      ).execute();
    } catch (e) {
      throw Exception('Erro ao iniciar percurso: $e');
    }
  }
}
