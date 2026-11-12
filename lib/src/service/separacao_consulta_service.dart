import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class SeparacaoConsultaService {
  static Future<List<ExpedicaoSeparacaoItemModel>> getSeparacaoItens({
    required int codEmpresa,
    required int codSepararEstoque,
  }) async {
    try {
      final separacaoItemRepository = SeparacaoItemRepository();
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodSepararEstoque', codSepararEstoque)
          .allRows();

      final separacaoItens = await separacaoItemRepository.select(queryBuilder);
      return separacaoItens;
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  static Future<List<ExpedicaoSeparacaoItemModel>> getSeparacaoItensCarrinho({
    required int codEmpresa,
    required int codCarrinhoPercurso,
    required String itemCarrinhoPercurso,
  }) async {
    try {
      final separacaoItemRepository = SeparacaoItemRepository();
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodCarrinhoPercurso', codCarrinhoPercurso)
          .equals('ItemCarrinhoPercurso', itemCarrinhoPercurso)
          .allRows();

      final separacaoItens = await separacaoItemRepository.select(queryBuilder);
      return separacaoItens;
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  static Future<List<ExpedicaoSeparacaoItemModel>>
  getSeparacaoItensCarrinhoPercurso({
    required int codEmpresa,
    required int codCarrinhoPercurso,
  }) async {
    try {
      final separacaoItemRepository = SeparacaoItemRepository();
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodCarrinhoPercurso', codCarrinhoPercurso)
          .allRows();

      final separacaoItens = await separacaoItemRepository.select(queryBuilder);
      return separacaoItens;
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }
}
