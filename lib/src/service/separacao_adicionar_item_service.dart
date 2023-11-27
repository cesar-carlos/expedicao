import 'package:app_expedicao/src/repository/expedicao_separar_item/separar_item_repository.dart';
import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_socket.config.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
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
      situacao: 'SP',
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

    final resp = await SeparacaoItemRepository().insert(itemSeparacao);
    if (resp == null) return null;

    final params = '''
          CodEmpresa = ${resp.codEmpresa} 
      AND CodSepararEstoque = ${resp.codSepararEstoque}
      AND Item = '${resp.item}'
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

    for (final item in separarItens) {
      final qtdSeparadaProduto = separacaoItens.where((el) {
        return el.codProduto == item.codProduto && el.situacao != 'CA';
      }).fold<double>(0.00, (acm, element) => acm + element.quantidade);

      final double qtdSeparar = (item.quantidade - qtdSeparadaProduto);

      if (qtdSeparar <= 0) continue;
      final itemSeparacao = ExpedicaoSeparacaoItemModel(
        codEmpresa: carrinhoPercurso.codEmpresa,
        codSepararEstoque: carrinhoPercurso.codOrigem,
        item: '',
        sessionId: _socket.id ?? '',
        situacao: 'SP',
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

      await SeparacaoItemRepository().insert(itemSeparacao);
    }

    //TODO:: implementar retorno

    return [];
  }
}
