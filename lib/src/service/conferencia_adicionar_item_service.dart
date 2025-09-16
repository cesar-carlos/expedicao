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

class ConferenciaAdicionarItemService {
  final _socket = Get.find<AppSocketConfig>().socket;

  final _processo = Get.find<ProcessoExecutavelModel>();
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;
  final conferenciaItemConsultaRepository = ConferenciaItemConsultaRepository();
  final conferirItemConsultaRepository = ConferirItemConsultaRepository();
  final conferenciaItemRepository = ConferenciaItemRepository();

  ConferenciaAdicionarItemService({
    required this.percursoEstagioConsulta,
  });

  Future<ExpedicaConferenciaItemConsultaModel?> add({
    required int codProduto,
    required String codUnidadeMedida,
    required double quantidade,
  }) async {
    try {
      final itemConferencia = ExpedicaoConferenciaItemModel(
        codEmpresa: percursoEstagioConsulta.codEmpresa,
        codConferir: percursoEstagioConsulta.codOrigem,
        item: '',
        sessionId: _socket.id ?? '',
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

      final newConferenciaItem =
          await conferenciaItemRepository.insert(itemConferencia);

      if (newConferenciaItem.isEmpty) return null;

      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', newConferenciaItem.last.codEmpresa)
          .equals('CodConferir', newConferenciaItem.last.codConferir)
          .equals('Item', newConferenciaItem.last.item);

      final list = await conferenciaItemConsultaRepository.select(queryBuilder);
      if (list.isEmpty) return null;
      return list.last;
    } catch (e) {
      throw Exception('Erro ao adicionar item à conferência: $e');
    }
  }

  Future<List<ExpedicaConferenciaItemConsultaModel>> addAll() async {
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
            0.00, (acm, el) => acm + el.quantidade);

        final double qtdConferir = (item.quantidade - qtdConferidaProduto);
        if (qtdConferir <= 0) continue;

        final itemConferencia = ExpedicaoConferenciaItemModel(
          codEmpresa: percursoEstagioConsulta.codEmpresa,
          codConferir: percursoEstagioConsulta.codOrigem,
          item: '',
          sessionId: _socket.id ?? '',
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

      final conferenciaItensResponse =
          await conferenciaItemRepository.insertAll(conferenciaItensInsert);

      final List<ExpedicaConferenciaItemConsultaModel> result = [];
      for (final item in conferenciaItensResponse) {
        final queryBuilder = QueryBuilder()
            .equals('CodEmpresa', item.codEmpresa)
            .equals('CodConferir', item.codConferir)
            .equals('Item', item.item);

        final items =
            await conferenciaItemConsultaRepository.select(queryBuilder);
        if (items.isNotEmpty) {
          result.addAll(items);
        }
      }

      return result;
    } catch (e) {
      throw Exception('Erro ao adicionar todos os itens à conferência: $e');
    }
  }

  Future<List<ExpedicaoConferirItemModel>> _getConferirItensCarrinho() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals('CodConferir', percursoEstagioConsulta.codOrigem)
          .equals('CodCarrinho', percursoEstagioConsulta.codCarrinho);

      final itens = await conferirItemConsultaRepository.select(queryBuilder);
      return itens
          .map((el) => ExpedicaoConferirItemModel.fromConsulta(el))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar itens de conferir do carrinho: $e');
    }
  }

  Future<List<ExpedicaoConferenciaItemModel>>
      _getConferenciaItensCarrinho() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals('CodConferir', percursoEstagioConsulta.codOrigem)
          .equals('CodCarrinhoPercurso',
              percursoEstagioConsulta.codCarrinhoPercurso)
          .equals('ItemCarrinhoPercurso', percursoEstagioConsulta.item);

      return await conferenciaItemRepository.select(queryBuilder);
    } catch (e) {
      throw Exception('Erro ao buscar itens de conferência do carrinho: $e');
    }
  }
}
