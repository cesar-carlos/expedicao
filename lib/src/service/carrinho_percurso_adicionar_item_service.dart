import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_socket.config.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';

class CarrinhoPercursoAdicionarItemService {
  final socket = Get.find<AppSocketConfig>().socket;
  final ExpedicaoCarrinhoPercursoModel carrinhoPercurso;
  final ExpedicaoPercursoEstagioConsultaModel percursoEstagioConsulta;
  final ProcessoExecutavelModel processo;

  CarrinhoPercursoAdicionarItemService({
    required this.carrinhoPercurso,
    required this.percursoEstagioConsulta,
    required this.processo,
  });

  Future<ExpedicaSeparacaoItemConsultaModel?> adicionar({
    required int codProduto,
    required String codUnidadeMedida,
    required double quantidade,
  }) async {
    final itemSeparacao = ExpedicaoSeparacaoItemModel(
      codEmpresa: carrinhoPercurso.codEmpresa,
      codSepararEstoque: carrinhoPercurso.codOrigem,
      item: '',
      sessionId: socket.id ?? '',
      situacao: 'SP',
      codCarrinhoPercurso: percursoEstagioConsulta.codCarrinhoPercurso,
      itemCarrinhoPercurso: percursoEstagioConsulta.item,
      codSeparador: processo.codUsuario,
      nomeSeparador: processo.nomeUsuario,
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
}
