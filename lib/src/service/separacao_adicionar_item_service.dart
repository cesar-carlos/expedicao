import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_socket.config.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separar_item/separar_item_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';

class SeparacaoAdicionarItemService {
  final _socket = Get.find<AppSocketConfig>().socket;
  final _processo = Get.find<ProcessoExecutavelModel>();

  final ExpedicaoCarrinhoPercursoModel carrinhoPercurso;
  final ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta;

  SeparacaoAdicionarItemService({
    required this.carrinhoPercurso,
    required this.percursoEstagioConsulta,
  });

  Future<ExpedicaSeparacaoItemConsultaModel?> add({
    required int codProduto,
    required String codUnidadeMedida,
    required double quantidade,
  }) async {
    final itemSeparacao = ExpedicaoSeparacaoItemModel(
      codEmpresa: carrinhoPercurso.codEmpresa,
      codSepararEstoque: carrinhoPercurso.codOrigem,
      item: '',
      sessionId: _socket.id ?? '',
      situacao: ExpedicaoItemSituacaoModel.separado,
      codCarrinhoPercurso: percursoEstagioConsulta.codCarrinhoPercurso,
      itemCarrinhoPercurso: percursoEstagioConsulta.item,
      codSeparador: _processo.codUsuario,
      nomeSeparador: _processo.nomeUsuario,
      dataSeparacao: DateTime.now(),
      horaSeparacao: DateTime.now().toIso8601String().substring(11, 19),
      codProduto: codProduto,
      codUnidadeMedida: codUnidadeMedida,
      quantidade: quantidade,
    );

    final newSeparacaoItem =
        await SeparacaoItemRepository().insert(itemSeparacao);

    if (newSeparacaoItem.isEmpty) return null;

    final params = '''
          CodEmpresa = ${newSeparacaoItem.first.codEmpresa} 
      AND CodSepararEstoque = ${newSeparacaoItem.first.codSepararEstoque}
      AND Item = '${newSeparacaoItem.first.item}'
    ''';

    final list = await SeparacaoItemConsultaRepository().select(params);
    if (list.isEmpty) return null;
    return list.first;
  }

  Future<List<ExpedicaSeparacaoItemConsultaModel>> addAll({
    required codEmpresa,
    required codSepararEstoque,
  }) async {
    final params = '''
          CodEmpresa = $codEmpresa
      AND CodSepararEstoque = $codSepararEstoque
    ''';

    final separarItens = await SepararItemRepository().select(params);
    final separacaoItens = await SeparacaoItemRepository().select(params);
    final List<ExpedicaoSeparacaoItemModel> separacaoItensInsert = [];

    for (final item in separarItens) {
      final separacaoItensFiltrado = separacaoItens.where((el) {
        return el.codProduto == item.codProduto &&
            el.situacao != ExpedicaoItemSituacaoModel.cancelado;
      }).toList();

      final qtdSeparadaProduto = separacaoItensFiltrado.fold<double>(
          0.00, (acm, element) => acm + element.quantidade);

      final double qtdSeparar = (item.quantidade - qtdSeparadaProduto);

      if (qtdSeparar <= 0) continue;
      final itemSeparacao = ExpedicaoSeparacaoItemModel(
        codEmpresa: carrinhoPercurso.codEmpresa,
        codSepararEstoque: carrinhoPercurso.codOrigem,
        item: '',
        sessionId: _socket.id ?? '',
        situacao: ExpedicaoItemSituacaoModel.separado,
        codCarrinhoPercurso: percursoEstagioConsulta.codCarrinhoPercurso,
        itemCarrinhoPercurso: percursoEstagioConsulta.item,
        codSeparador: _processo.codUsuario,
        nomeSeparador: _processo.nomeUsuario,
        dataSeparacao: DateTime.now(),
        horaSeparacao: DateTime.now().toIso8601String().substring(11, 19),
        codProduto: item.codProduto,
        codUnidadeMedida: item.codUnidadeMedida,
        quantidade: qtdSeparar,
      );

      separacaoItensInsert.add(itemSeparacao);
    }

    final separacaoItensResponse =
        await SeparacaoItemRepository().insertAll(separacaoItensInsert);

    final paramsConsulta = separacaoItensResponse.map<String>((el) {
      if (separacaoItensResponse.first == el) {
        return ''' 
              CodEmpresa = ${el.codEmpresa} 
          AND CodSepararEstoque = ${el.codSepararEstoque}
          AND (Item = '${el.item}'
        ''';
      }

      if (separacaoItensResponse.last == el) {
        return ''' Item = '${el.item}' ) ''';
      }

      return ''' Item = '${el.item}'  ''';
    }).join('OR');

    return await SeparacaoItemConsultaRepository().select(paramsConsulta);
  }
}
