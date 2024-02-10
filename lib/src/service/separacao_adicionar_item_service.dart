import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separar_item/separar_item_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';

class SeparacaoAdicionarItemService {
  final _socket = Get.find<AppSocketConfig>().socket;
  final _processo = Get.find<ProcessoExecutavelModel>();

  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;

  SeparacaoAdicionarItemService({
    required this.percursoEstagioConsulta,
  });

  Future<ExpedicaSeparacaoItemConsultaModel?> add({
    required int codProduto,
    required String codUnidadeMedida,
    required double quantidade,
  }) async {
    try {
      final itemSeparacao = ExpedicaoSeparacaoItemModel(
        codEmpresa: percursoEstagioConsulta.codEmpresa,
        codSepararEstoque: percursoEstagioConsulta.codOrigem,
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
      if (newSeparacaoItem.length == 0) return null;

      final params = '''
        CodEmpresa = ${newSeparacaoItem.first.codEmpresa} 
          AND CodSepararEstoque = ${newSeparacaoItem.first.codSepararEstoque}
          AND Item = '${newSeparacaoItem.first.item}' ''';

      final list = await SeparacaoItemConsultaRepository().select(params);
      if (list.isEmpty) return null;
      return list.first;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ExpedicaSeparacaoItemConsultaModel>> addAll() async {
    final params = '''
        CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodSepararEstoque = ${percursoEstagioConsulta.codOrigem}

    ''';

    final separarItens = await SepararItemRepository().select(params);
    final separacaoItens = await SeparacaoItemRepository().select(params);

    final List<ExpedicaoSeparacaoItemModel> separacaoItensInsert = [];

    for (final item in separarItens) {
      final separacaoItensFiltrado = separacaoItens.where((el) {
        return el.codEmpresa == item.codEmpresa &&
            el.codSepararEstoque == item.codSepararEstoque &&
            el.codProduto == item.codProduto &&
            el.situacao != ExpedicaoItemSituacaoModel.cancelado;
      }).toList();

      final qtdSeparadaProduto = separacaoItensFiltrado.fold<double>(
          0.00, (acm, el) => acm + el.quantidade);

      final double qtdSeparar = (item.quantidade - qtdSeparadaProduto);
      if (qtdSeparar <= 0) continue;

      final itemSeparacao = ExpedicaoSeparacaoItemModel(
        codEmpresa: percursoEstagioConsulta.codEmpresa,
        codSepararEstoque: percursoEstagioConsulta.codOrigem,
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

    String paramsConsulta = separacaoItensResponse.map((el) {
      return '''
        (CodEmpresa = ${el.codEmpresa} 
      AND CodSepararEstoque = ${el.codSepararEstoque}
      AND Item = '${el.item}')

      ''';
    }).join(' OR ');

    return await SeparacaoItemConsultaRepository().select(paramsConsulta);
  }
}
