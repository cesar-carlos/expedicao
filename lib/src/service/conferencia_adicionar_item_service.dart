import 'socket_mutation_action.dart';

import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferencia_item/conferencia_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferencia_item/conferencia_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_helper.dart';

class ConferenciaAdicionarItemService {
  final _socket = Get.find<AppSocketConfig>();

  final _processo = Get.find<ProcessoExecutavelModel>();
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;
  final conferenciaItemConsultaRepository = ConferenciaItemConsultaRepository();
  final conferirItemConsultaRepository = ConferirItemConsultaRepository();
  final conferenciaItemRepository = ConferenciaItemRepository();

  ConferenciaAdicionarItemService({required this.percursoEstagioConsulta});

  Future<ExpedicaConferenciaItemConsultaModel?> add({
    required int codProduto,
    required String codUnidadeMedida,
    required double quantidade,
  }) async {
    return runSocketMutation(() async {
      try {
        final itemConferencia = ExpedicaoConferenciaItemModel(
          codEmpresa: percursoEstagioConsulta.codEmpresa,
          codConferir: percursoEstagioConsulta.codOrigem,
          item: '',
          sessionId: _socket.sessionId ?? '',
          situacao: ExpedicaoItemSituacaoModel.conferido,
          codCarrinhoPercurso: percursoEstagioConsulta.codCarrinhoPercurso,
          itemCarrinhoPercurso: percursoEstagioConsulta.item,
          codConferente: _processo.codUsuario,
          nomeConferente: _processo.nomeUsuario,
          dataConferencia: DateTime.now(),
          horaConferencia: DateTime.now().toIso8601String().substring(11, 19),
          codProduto: codProduto,
          codUnidadeMedida: codUnidadeMedida,
          quantidade: quantidade,
        );

        final newConferenciaItem = await conferenciaItemRepository.insert(
          itemConferencia,
        );

        if (newConferenciaItem.isEmpty) {
          throw AppError('Gravação sem confirmação dos itens.');
        }

        final list = await conferenciaItemConsultaRepository.select(
          _queryConsultaItem(newConferenciaItem.last),
        );
        if (list.length != 1 ||
            !AppHelper.sameGridItem(
              list.single.item,
              newConferenciaItem.single.item,
            )) {
          throw AppError('Item gravado, mas a consulta não confirmou a linha.');
        }
        return list.last;
      } catch (e) {
        throw AppError.fromUnknown(e);
      }
    });
  }

  Future<List<ExpedicaConferenciaItemConsultaModel>> addAll() async {
    return runSocketMutation(() async {
      try {
        final List<ExpedicaoConferenciaItemModel> conferenciaItensInsert = [];
        final conferenciaItens = await _getConferenciaItensCarrinho();
        final conferirItens = await _getConferirItensCarrinho();

        for (final item in conferirItens) {
          final conferenciaItensFiltrado = conferenciaItens.where((el) {
            return el.codEmpresa == item.codEmpresa &&
                el.codConferir == item.codConferir &&
                el.codProduto == item.codProduto &&
                el.situacao != ExpedicaoItemSituacaoModel.cancelado;
          }).toList();

          final qtdConferidaProduto = conferenciaItensFiltrado.fold<double>(
            0.00,
            (acm, el) => acm + el.quantidade,
          );

          final double qtdConferir = (item.quantidade - qtdConferidaProduto);
          if (qtdConferir <= 0) continue;

          final itemConferencia = ExpedicaoConferenciaItemModel(
            codEmpresa: percursoEstagioConsulta.codEmpresa,
            codConferir: percursoEstagioConsulta.codOrigem,
            item: '',
            sessionId: _socket.sessionId ?? '',
            situacao: ExpedicaoItemSituacaoModel.conferido,
            codCarrinhoPercurso: percursoEstagioConsulta.codCarrinhoPercurso,
            itemCarrinhoPercurso: percursoEstagioConsulta.item,
            codConferente: _processo.codUsuario,
            nomeConferente: _processo.nomeUsuario,
            dataConferencia: DateTime.now(),
            horaConferencia: DateTime.now().toIso8601String().substring(11, 19),
            codProduto: item.codProduto,
            codUnidadeMedida: item.codUnidadeMedida,
            quantidade: qtdConferir,
          );

          conferenciaItensInsert.add(itemConferencia);
        }

        if (conferenciaItensInsert.isEmpty) {
          return [];
        }

        final conferenciaItensResponse = await conferenciaItemRepository
            .insertAll(conferenciaItensInsert);

        if (conferenciaItensResponse.isEmpty) {
          return [];
        }

        final firstItem = conferenciaItensResponse.first;
        final allItems = await conferenciaItemConsultaRepository.select(
          QueryBuilder()
              .equals('CodEmpresa', firstItem.codEmpresa)
              .equals('CodConferir', firstItem.codConferir)
              .equals('CodCarrinho', percursoEstagioConsulta.codCarrinho)
              .allRows(),
        );

        final result = allItems.where((consulta) {
          return conferenciaItensResponse.any(
            (inserted) => AppHelper.sameGridItem(consulta.item, inserted.item),
          );
        }).toList();

        if (result.length != conferenciaItensResponse.length ||
            conferenciaItensResponse.any(
              (inserted) =>
                  result
                      .where(
                        (row) =>
                            AppHelper.sameGridItem(row.item, inserted.item),
                      )
                      .length !=
                  1,
            )) {
          throw AppError(
            'Itens gravados, mas a consulta não retornou as linhas.',
          );
        }

        return result;
      } catch (e) {
        throw AppError.fromUnknown(e);
      }
    });
  }

  Future<List<ExpedicaoConferirItemModel>> _getConferirItensCarrinho() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals('CodConferir', percursoEstagioConsulta.codOrigem)
          .equals('CodCarrinho', percursoEstagioConsulta.codCarrinho)
          .allRows();

      final itens = await conferirItemConsultaRepository.select(queryBuilder);
      return itens
          .map((el) => ExpedicaoConferirItemModel.fromConsulta(el))
          .toList();
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<List<ExpedicaoConferenciaItemModel>>
  _getConferenciaItensCarrinho() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals('CodConferir', percursoEstagioConsulta.codOrigem)
          .equals(
            'CodCarrinhoPercurso',
            percursoEstagioConsulta.codCarrinhoPercurso,
          )
          .equals(
            'ItemCarrinhoPercurso',
            AppHelper.itemSequenceKey(percursoEstagioConsulta.item),
          )
          .allRows();

      return await conferenciaItemRepository.select(queryBuilder);
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  QueryBuilder _queryConsultaItem(ExpedicaoConferenciaItemModel item) {
    return QueryBuilder()
        .equals('CodEmpresa', item.codEmpresa)
        .equals('CodConferir', item.codConferir)
        .equals('CodCarrinho', percursoEstagioConsulta.codCarrinho)
        .equals('Item', AppHelper.itemSequenceKey(item.item));
  }
}
