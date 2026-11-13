import 'socket_mutation_action.dart';
import '../repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import '../repository/expedicao_carrinhos/carrinho_repository.dart';
import '../repository/expedicao_separar/separar_repository.dart';
import '../model/expedicao_situacao_model.dart';
import 'separacao_recuperacao_quantidade.dart';

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
import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_helper.dart';

class SeparacaoAdicionarItemService {
  final _socket = Get.find<AppSocketConfig>();
  final _processo = Get.find<ProcessoExecutavelModel>();

  final separacaoItemRepository = SeparacaoItemRepository();
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;
  final separacaoItemConsultaRepository = SeparacaoItemConsultaRepository();
  final separarItemRepository = SepararItemRepository();

  SeparacaoAdicionarItemService({required this.percursoEstagioConsulta});

  Future<ExpedicaSeparacaoItemConsultaModel?> add({
    required int codProduto,
    required String codUnidadeMedida,
    required double quantidade,
  }) async {
    return runSocketMutation(() async {
      try {
        final itemSeparacao = ExpedicaoSeparacaoItemModel(
          codEmpresa: percursoEstagioConsulta.codEmpresa,
          codSepararEstoque: percursoEstagioConsulta.codOrigem,
          item: '',
          sessionId: _socket.sessionId ?? '',
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

        final newSeparacaoItem = await separacaoItemRepository.insert(
          itemSeparacao,
        );

        if (newSeparacaoItem.isEmpty) {
          throw AppError('Gravação sem confirmação dos itens.');
        }

        final queryBuilder = QueryBuilder()
            .equals('CodEmpresa', newSeparacaoItem.first.codEmpresa)
            .equals(
              'CodSepararEstoque',
              newSeparacaoItem.first.codSepararEstoque,
            )
            .equals(
              'Item',
              AppHelper.itemSequenceKey(newSeparacaoItem.first.item),
            );

        final list = await separacaoItemConsultaRepository.select(queryBuilder);
        if (list.length != 1 ||
            !AppHelper.sameGridItem(
              list.single.item,
              newSeparacaoItem.single.item,
            )) {
          throw AppError('Item gravado, mas a consulta não confirmou a linha.');
        }
        return list.first;
      } catch (e) {
        throw AppError.fromUnknown(e);
      }
    });
  }

  Future<List<ExpedicaSeparacaoItemConsultaModel>> addAll() async {
    return runSocketMutation(() async {
      try {
        final queryBuilder = QueryBuilder()
            .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
            .equals('CodSepararEstoque', percursoEstagioConsulta.codOrigem)
            .allRows();

        final separarItens = await separarItemRepository.select(queryBuilder);
        final separacaoItens = await separacaoItemRepository.select(
          queryBuilder,
        );

        final List<ExpedicaoSeparacaoItemModel> separacaoItensInsert = [];

        for (final item in separarItens) {
          final separacaoItensFiltrado = separacaoItens.where((el) {
            return el.codEmpresa == item.codEmpresa &&
                el.codSepararEstoque == item.codSepararEstoque &&
                el.codProduto == item.codProduto &&
                el.situacao != ExpedicaoItemSituacaoModel.cancelado;
          }).toList();

          final qtdSeparadaProduto = separacaoItensFiltrado.fold<double>(
            0.00,
            (acm, el) => acm + el.quantidade,
          );

          final double qtdSeparar = (item.quantidade - qtdSeparadaProduto);
          if (qtdSeparar <= 0) continue;

          final itemSeparacao = ExpedicaoSeparacaoItemModel(
            codEmpresa: percursoEstagioConsulta.codEmpresa,
            codSepararEstoque: percursoEstagioConsulta.codOrigem,
            item: '',
            sessionId: _socket.sessionId ?? '',
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

        final separacaoItensResponse = await separacaoItemRepository.insertAll(
          separacaoItensInsert,
        );

        if (separacaoItensResponse.isEmpty) {
          return [];
        }

        final firstItem = separacaoItensResponse.first;
        final consultaQuery = QueryBuilder()
            .equals('CodEmpresa', firstItem.codEmpresa)
            .equals('CodSepararEstoque', firstItem.codSepararEstoque)
            .equals(
              'CodCarrinhoPercurso',
              percursoEstagioConsulta.codCarrinhoPercurso,
            )
            .equals(
              'ItemCarrinhoPercurso',
              AppHelper.itemSequenceKey(percursoEstagioConsulta.item),
            )
            .allRows();

        final allItems = await separacaoItemConsultaRepository.select(
          consultaQuery,
        );

        final insertedItems = allItems.where((item) {
          return separacaoItensResponse.any(
            (inserted) => AppHelper.sameGridItem(inserted.item, item.item),
          );
        }).toList();

        if (insertedItems.length != separacaoItensResponse.length ||
            separacaoItensResponse.any(
              (inserted) =>
                  insertedItems
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

        return insertedItems;
      } catch (e) {
        throw AppError.fromUnknown(e);
      }
    });
  }

  /// Re-adds items from a cancelled cart stage into [percursoEstagioConsulta].
  ///
  /// Skips products not on the order, outside the user's sector, or already
  /// fully separated. Caps quantity so the order is not exceeded.
  Future<List<ExpedicaSeparacaoItemConsultaModel>> addRecuperados(
    List<ExpedicaoSeparacaoItemModel> itensRecuperado,
  ) async {
    return runSocketMutation(() async {
      try {
        if (itensRecuperado.isEmpty) return [];
        final destino = percursoEstagioConsulta;
        final history = await CarrinhoPercursoEstagioRepository().select(
          QueryBuilder()
              .equals('CodEmpresa', destino.codEmpresa)
              .equals('CodCarrinho', destino.codCarrinho)
              .allRows(),
        );
        history.sort((a, b) {
          final percurso = a.codCarrinhoPercurso.compareTo(
            b.codCarrinhoPercurso,
          );
          return percurso != 0
              ? percurso
              : int.parse(a.item).compareTo(int.parse(b.item));
        });
        if (history.length < 2) {
          throw AppError('Histórico insuficiente para recuperar itens.');
        }
        final atual = history.last;
        final origem = history[history.length - 2];
        if (atual.codCarrinhoPercurso != destino.codCarrinhoPercurso ||
            !AppHelper.sameGridItem(atual.item, destino.item) ||
            atual.origem != 'SE' ||
            atual.codOrigem != destino.codOrigem ||
            ![
              ExpedicaoSituacaoModel.emSeparacao,
              ExpedicaoSituacaoModel.separando,
            ].contains(atual.situacao) ||
            origem.origem != 'SE' ||
            origem.codOrigem != destino.codOrigem ||
            origem.situacao != ExpedicaoSituacaoModel.cancelada) {
          throw AppError(
            'O carrinho mudou de estágio ou documento. Recarregue antes de recuperar.',
          );
        }
        final cadastro = await CarrinhoRepository().select(
          QueryBuilder()
              .equals('CodEmpresa', destino.codEmpresa)
              .equals('CodCarrinho', destino.codCarrinho)
              .allRows(),
        );
        final documento = await SepararRepository().select(
          QueryBuilder()
              .equals('CodEmpresa', destino.codEmpresa)
              .equals('CodSepararEstoque', destino.codOrigem)
              .allRows(),
        );
        if (cadastro.length != 1 ||
            cadastro.single.situacao != 'EM SEPARACAO' ||
            documento.length != 1 ||
            documento.single.situacao == ExpedicaoSituacaoModel.separado ||
            documento.single.situacao == ExpedicaoSituacaoModel.cancelada) {
          throw AppError('Cadastro ou documento não permite recuperar itens.');
        }
        if (itensRecuperado.any(
          (item) =>
              item.codEmpresa != destino.codEmpresa ||
              item.codSepararEstoque != destino.codOrigem ||
              item.codCarrinhoPercurso != origem.codCarrinhoPercurso ||
              !AppHelper.sameGridItem(item.itemCarrinhoPercurso, origem.item),
        )) {
          throw AppError('A origem da recuperação mudou. Recarregue os itens.');
        }
        final queryBuilder = QueryBuilder()
            .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
            .equals('CodSepararEstoque', percursoEstagioConsulta.codOrigem)
            .allRows();

        final separarItens = await separarItemRepository.select(queryBuilder);
        final separacaoItens = await separacaoItemRepository.select(
          queryBuilder,
        );
        final cancelados = separacaoItens
            .where(
              (item) =>
                  item.codCarrinhoPercurso == origem.codCarrinhoPercurso &&
                  AppHelper.sameGridItem(
                    item.itemCarrinhoPercurso,
                    origem.item,
                  ),
            )
            .toList();
        if (cancelados.isEmpty ||
            cancelados.any(
              (item) => item.situacao != ExpedicaoItemSituacaoModel.cancelado,
            )) {
          throw AppError(
            'Cancelamento incompleto ou itens ausentes. Revise antes de recuperar.',
          );
        }
        final processados = <String>{};
        final added = <ExpedicaSeparacaoItemConsultaModel>[];

        for (final item in cancelados) {
          final chave = '${item.codProduto}|${item.codUnidadeMedida}';
          if (!processados.add(chave)) continue;

          final pedido = separarItens.where((el) {
            return el.codProduto == item.codProduto &&
                el.codUnidadeMedida == item.codUnidadeMedida;
          }).firstOrNull;

          if (pedido == null) continue;

          if (!AppHelper.setorPermitido(
            _processo.codSetorEstoque,
            pedido.codSetorEstoque,
          )) {
            continue;
          }

          final qtdJaSeparada = separacaoItens
              .where((el) {
                return el.codProduto == item.codProduto &&
                    el.codUnidadeMedida == item.codUnidadeMedida &&
                    el.situacao != ExpedicaoItemSituacaoModel.cancelado;
              })
              .fold<double>(0, (acm, el) => acm + el.quantidade);

          final qtd = quantidadeRecuperacaoPendente(
            quantidadeCancelada: cancelados
                .where(
                  (el) =>
                      el.codProduto == item.codProduto &&
                      el.codUnidadeMedida == item.codUnidadeMedida,
                )
                .fold<double>(0, (total, el) => total + el.quantidade),
            quantidadeDestino: separacaoItens
                .where(
                  (el) =>
                      el.codCarrinhoPercurso == destino.codCarrinhoPercurso &&
                      AppHelper.sameGridItem(
                        el.itemCarrinhoPercurso,
                        destino.item,
                      ) &&
                      el.codProduto == item.codProduto &&
                      el.codUnidadeMedida == item.codUnidadeMedida &&
                      el.situacao != ExpedicaoItemSituacaoModel.cancelado,
                )
                .fold<double>(0, (total, el) => total + el.quantidade),
            quantidadePedido: pedido.quantidade,
            quantidadeJaSeparada: qtdJaSeparada,
          );
          if (qtd <= 0) continue;

          final inserted = await add(
            codProduto: item.codProduto,
            codUnidadeMedida: item.codUnidadeMedida,
            quantidade: qtd,
          );
          if (inserted == null) continue;

          added.add(inserted);
        }

        return added;
      } catch (e) {
        throw AppError.fromUnknown(e);
      }
    });
  }
}
