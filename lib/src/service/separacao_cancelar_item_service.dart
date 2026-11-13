import 'socket_mutation_action.dart';

import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_helper.dart';

class SeparacaoCancelarItemService {
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;
  final separacaoItemConsultaRepository = SeparacaoItemConsultaRepository();
  final separacaoItemRepository = SeparacaoItemRepository();

  SeparacaoCancelarItemService({required this.percursoEstagioConsulta});

  Future<void> cancelar({required String item}) async {
    return runSocketMutation(() async {
      try {
        final queryBuilder = QueryBuilder()
            .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
            .equals('CodSepararEstoque', percursoEstagioConsulta.codOrigem)
            .equals('Item', AppHelper.itemSequenceKey(item));

        final response = await separacaoItemRepository.select(queryBuilder);

        for (var el in response) {
          final newItem = el.copyWith(
            situacao: ExpedicaoItemSituacaoModel.cancelado,
          );

          await separacaoItemRepository.update(newItem);
        }
      } catch (e) {
        throw AppError.fromUnknown(e);
      }
    });
  }

  Future<void> cancelarAll() async {
    return runSocketMutation(() async {
      try {
        final separacaoItens = await _getSeparacaoItens();
        final newItens = separacaoItens.map((el) {
          return el.copyWith(situacao: ExpedicaoItemSituacaoModel.cancelado);
        }).toList();

        await separacaoItemRepository.updateAll(newItens);
      } catch (e) {
        throw AppError.fromUnknown(e);
      }
    });
  }

  Future<void> cancelarAllItensCart() async {
    return runSocketMutation(() async {
      try {
        final separacaoItens = await _getSeparacaoItensCarrinho();
        final newItens = separacaoItens.map((el) {
          return ExpedicaoSeparacaoItemModel.fromConsulta(el)
              .copyWith(situacao: ExpedicaoItemSituacaoModel.cancelado);
        }).toList();

        await separacaoItemRepository.updateAll(newItens);
      } catch (e) {
        throw AppError.fromUnknown(e);
      }
    });
  }

  Future<List<ExpedicaSeparacaoItemConsultaModel>>
  _getSeparacaoItensCarrinho() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals('CodSepararEstoque', percursoEstagioConsulta.codOrigem)
          .equals(
            'CodCarrinhoPercurso',
            percursoEstagioConsulta.codCarrinhoPercurso,
          )
          .equals('ItemCarrinhoPercurso', percursoEstagioConsulta.item)
          .allRows();

      return await separacaoItemConsultaRepository.select(queryBuilder);
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<List<ExpedicaoSeparacaoItemModel>> _getSeparacaoItens() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals('CodSepararEstoque', percursoEstagioConsulta.codOrigem)
          .allRows();

      return await separacaoItemRepository.select(queryBuilder);
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }
}
