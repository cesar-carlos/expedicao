import 'package:app_expedicao/src/model/expedicao_cancelamento_model.dart';
import 'package:app_expedicao/src/repository/expedicao_cancelamento/cancelamento_repository.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class CancelamentoService {
  final cancelamentoRepository = CancelamentoRepository();

  CancelamentoService();

  Future<List<ExpedicaoCancelamentoModel>> selectOrigem({
    required int codEmpresa,
    required String origem,
    required int codOrigem,
    String? itemOrigem,
  }) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('Origem', origem)
          .equals('CodOrigem', codOrigem)
          .allRows(orderField: 'CodCancelamento');

      if (itemOrigem != null) {
        queryBuilder.equals('ItemOrigem', itemOrigem);
      }

      final result = await cancelamentoRepository.select(queryBuilder);
      return result;
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<ExpedicaoCancelamentoModel?> selectOrigemWithItem({
    required int codEmpresa,
    required String origem,
    required int codOrigem,
    required String itemOrigem,
  }) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('Origem', origem)
          .equals('CodOrigem', codOrigem)
          .equals('ItemOrigem', itemOrigem);

      final result = await cancelamentoRepository.select(queryBuilder);

      if (result.isEmpty) return null;

      return result.first;
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }
}
