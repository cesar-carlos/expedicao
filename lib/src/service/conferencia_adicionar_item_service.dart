import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferencia_item/conferencia_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferencia_item/conferencia_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';

class ConferenciaAdicionarItemService {
  final _socket = Get.find<AppSocketConfig>().socket;
  final _processo = Get.find<ProcessoExecutavelModel>();

  final ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta;

  ConferenciaAdicionarItemService({
    required this.percursoEstagioConsulta,
  });

  Future<ExpedicaConferenciaItemConsultaModel?> add({
    required int codProduto,
    required String codUnidadeMedida,
    required double quantidade,
  }) async {
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
        await ConferenciaItemRepository().insert(itemConferencia);

    if (newConferenciaItem.isEmpty) return null;

    final params = '''
        CodEmpresa = ${newConferenciaItem.last.codEmpresa} 
      AND CodConferir = ${newConferenciaItem.last.codConferir}
      AND Item = '${newConferenciaItem.last.item}'

    ''';

    final list = await ConferenciaItemConsultaRepository().select(params);
    if (list.isEmpty) return null;
    return list.last;
  }

  Future<List<ExpedicaConferenciaItemConsultaModel>> addAll() async {
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
        await ConferenciaItemRepository().insertAll(conferenciaItensInsert);

    String paramsConsulta = conferenciaItensResponse.map((el) {
      return '''
        (CodEmpresa = ${el.codEmpresa} 
      AND CodConferir = ${el.codConferir}
      AND Item = '${el.item}')

      ''';
    }).join(' OR ');

    return await ConferenciaItemConsultaRepository().select(paramsConsulta);
  }

  Future<List<ExpedicaoConferirItemModel>> _getConferirItensCarrinho() async {
    final params = '''
        CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodConferir = ${percursoEstagioConsulta.codOrigem}
      AND CodCarrinho = '${percursoEstagioConsulta.codCarrinho}'

    ''';

    final itens = await ConferirItemConsultaRepository().select(params);
    return itens
        .map((el) => ExpedicaoConferirItemModel.fromConsulta(el))
        .toList();
  }

  Future<List<ExpedicaoConferenciaItemModel>>
      _getConferenciaItensCarrinho() async {
    final params = '''
        CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodConferir = ${percursoEstagioConsulta.codOrigem}
      AND CodCarrinhoPercurso = ${percursoEstagioConsulta.codCarrinhoPercurso}  
      AND ItemCarrinhoPercurso = '${percursoEstagioConsulta.item}'

    ''';

    return await ConferenciaItemRepository().select(params);
  }
}
