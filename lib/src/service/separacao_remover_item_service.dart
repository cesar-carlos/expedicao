import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';

class SeparacaoRemoverItemService {
  Future<void> remove({
    required codEmpresa,
    required codSepararEstoque,
    required item,
  }) async {
    final repository = SeparacaoItemRepository();
    final response = await repository.select(
      '''
          CodEmpresa = $codEmpresa
      AND CodSepararEstoque = $codSepararEstoque
      AND Item = '$item'
      ''',
    );

    for (var el in response) {
      await repository.delete(el);
    }
  }

  Future<void> removeAll({
    required codEmpresa,
    required codSepararEstoque,
  }) async {
    final repository = SeparacaoItemRepository();
    final response = await repository.select(
      '''
          CodEmpresa = $codEmpresa
      AND CodSepararEstoque = $codSepararEstoque
      ''',
    );

    repository.deleteall(response);
  }
}
