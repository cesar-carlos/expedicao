import 'socket_mutation_action.dart';

import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_helper.dart';

class SeparacaoRemoverItemService {
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;
  final separacaoItemConsultaRepository = SeparacaoItemConsultaRepository();
  final separacaoItemRepository = SeparacaoItemRepository();

  SeparacaoRemoverItemService({required this.percursoEstagioConsulta});

  Future<void> remove({required String item}) async {
    return runSocketMutation(() async {
      try {
        final itemKey = AppHelper.itemSequenceKey(item);
        final queryBuilder = QueryBuilder()
            .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
            .equals('CodSepararEstoque', percursoEstagioConsulta.codOrigem)
            .equals('Item', itemKey);

        final response = await separacaoItemRepository.select(queryBuilder);
        if (response.isEmpty) {
          throw AppError(
            'Item não encontrado para exclusão.',
            details: 'Item=$itemKey',
          );
        }

        for (var el in response) {
          await separacaoItemRepository.delete(el);
        }
      } catch (e) {
        throw AppError.fromUnknown(e);
      }
    });
  }

  Future<void> removeAll() async {
    return runSocketMutation(() async {
      try {
        final queryBuilder = QueryBuilder()
            .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
            .equals('CodSepararEstoque', percursoEstagioConsulta.codOrigem)
            .allRows();

        final response = await separacaoItemRepository.select(queryBuilder);
        await separacaoItemRepository.deleteAll(response);
      } catch (e) {
        throw AppError.fromUnknown(e);
      }
    });
  }

  Future<void> removeAllItensCart() async {
    return runSocketMutation(() async {
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

        final separacaoItensConsulta = await separacaoItemConsultaRepository
            .select(queryBuilder);

        final itensDel = separacaoItensConsulta.map((el) {
          return ExpedicaoSeparacaoItemModel.fromConsulta(el);
        }).toList();

        await separacaoItemRepository.deleteAll(itensDel);
      } catch (e) {
        throw AppError.fromUnknown(e);
      }
    });
  }
}
