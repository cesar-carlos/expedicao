import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separar_item/separar_item_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class SeparacaoAdicionarItemService {
  final _socket = Get.find<AppSocketConfig>().socket;
  final _processo = Get.find<ProcessoExecutavelModel>();

  final separacaoItemRepository = SeparacaoItemRepository();
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;
  final separacaoItemConsultaRepository = SeparacaoItemConsultaRepository();
  final separarItemRepository = SepararItemRepository();

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
          await separacaoItemRepository.insert(itemSeparacao);

      if (newSeparacaoItem.isEmpty) return null;

      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', newSeparacaoItem.first.codEmpresa)
          .equals('CodSepararEstoque', newSeparacaoItem.first.codSepararEstoque)
          .equals('Item', newSeparacaoItem.first.item);

      final list = await separacaoItemConsultaRepository.select(queryBuilder);
      if (list.isEmpty) return null;
      return list.first;
    } catch (e) {
      throw Exception('Erro ao adicionar item à separação: $e');
    }
  }

  Future<List<ExpedicaSeparacaoItemConsultaModel>> addAll() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals('CodSepararEstoque', percursoEstagioConsulta.codOrigem);

      final separarItens = await separarItemRepository.select(queryBuilder);
      final separacaoItens = await separacaoItemRepository.select(queryBuilder);

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

      if (separacaoItensInsert.isEmpty) {
        return [];
      }

      final separacaoItensResponse =
          await separacaoItemRepository.insertAll(separacaoItensInsert);

      if (separacaoItensResponse.isNotEmpty) {
        final firstItem = separacaoItensResponse.first;
        final queryBuilder = QueryBuilder()
            .equals('CodEmpresa', firstItem.codEmpresa)
            .equals('CodSepararEstoque', firstItem.codSepararEstoque);

        final allItems =
            await separacaoItemConsultaRepository.select(queryBuilder);

        final insertedItems = allItems.where((item) {
          return separacaoItensResponse
              .any((inserted) => inserted.item == item.item);
        }).toList();

        return insertedItems;
      }

      return [];
    } catch (e) {
      throw Exception('Erro ao adicionar todos os itens à separação: $e');
    }
  }
}
