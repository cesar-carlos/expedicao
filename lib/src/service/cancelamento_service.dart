import 'package:app_expedicao/src/model/expedicao_cancelamento_model.dart';
import 'package:app_expedicao/src/repository/expedicao_cancelamento/cancelamento_repository.dart';

class CancelamentoService {
  late CancelamentoRepository _cancelamentoRepository;

  CancelamentoService() {
    _cancelamentoRepository = CancelamentoRepository();
  }

  Future<List<ExpedicaoCancelamentoModel>> selectOrigem({
    required int codEmpresa,
    required String origem,
    required int codOrigem,
    String? itemOrigem,
  }) async {
    final params = '''
        CodEmpresa = $codEmpresa
        AND Origem = '$origem'
        AND CodOrigem = $codOrigem
        ${itemOrigem != null ? 'AND ItemOrigem = $itemOrigem' : ''} ''';

    final result = await _cancelamentoRepository.select(params);
    return result;
  }

  Future<ExpedicaoCancelamentoModel?> selectOrigemWithItem({
    required int codEmpresa,
    required String origem,
    required int codOrigem,
    required String itemOrigem,
  }) async {
    final params = '''
        CodEmpresa = $codEmpresa
        AND Origem = '$origem'
        AND CodOrigem = $codOrigem
        AND ItemOrigem = $itemOrigem ''';

    final result = await _cancelamentoRepository.select(params);
    if (result.isEmpty) return null;

    return result.first;
  }
}
