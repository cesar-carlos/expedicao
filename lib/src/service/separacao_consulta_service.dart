import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';

class SeparacaoConsultaService {
  static Future<List<ExpedicaoSeparacaoItemModel>> getSeparacaoItens({
    required int codEmpresa,
    required int codSepararEstoque,
  }) async {
    final separacaoItemRepository = SeparacaoItemRepository();

    final separacaoItens = await separacaoItemRepository.select(
      'codEmpresa = $codEmpresa and codSepararEstoque = $codSepararEstoque',
    );

    return separacaoItens;
  }

  static Future<List<ExpedicaoSeparacaoItemModel>> getSeparacaoItensCarrinho({
    required int codEmpresa,
    required int codCarrinhoPercurso,
    required String itemCarrinhoPercurso,
  }) async {
    final separacaoItemRepository = SeparacaoItemRepository();
    final params = ''' CodEmpresa = $codEmpresa 
        AND CodCarrinhoPercurso = $codCarrinhoPercurso 
        AND ItemCarrinhoPercurso = '$itemCarrinhoPercurso' ''';

    final separacaoItens = await separacaoItemRepository.select(params);
    return separacaoItens;
  }

  static Future<List<ExpedicaoSeparacaoItemModel>>
      getSeparacaoItensCarrinhoPercurso({
    required int codEmpresa,
    required int codCarrinhoPercurso,
  }) async {
    final separacaoItemRepository = SeparacaoItemRepository();

    final separacaoItens = await separacaoItemRepository.select(
      'CodEmpresa = $codEmpresa and CodCarrinhoPercurso = $codCarrinhoPercurso',
    );

    return separacaoItens;
  }
}
