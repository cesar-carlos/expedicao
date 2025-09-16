import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/model/expedicao_separado_item_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_consulta_separacao_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_repository.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';

class ConferirSeparacaoAdicionarService {
  final conferirRepository = ConferirRepository();
  final ExpedicaoCarrinhoPercursoModel carrinhoPercurso;
  final conferirItemRepository = ConferirItemRepository();

  final conferirItemConsultaSeparacaoRepository =
      ConferirItemConsultaSeparacaoRepository();

  ConferirSeparacaoAdicionarService(this.carrinhoPercurso);

  Future<void> execute() async {
    try {
      final itensSeparacaoConsulta = await _findSeparado();
      final conferir = _createConferir(itensSeparacaoConsulta.first);
      final result = await conferirRepository.insert(conferir);

      final newItensConferir = _createItensConferir(
        result.first,
        itensSeparacaoConsulta,
      );

      await conferirItemRepository.insertAll(newItensConferir);
    } catch (e) {
      if (e is AppError) rethrow;
      throw Exception('Erro ao adicionar conferência de separação: $e');
    }
  }

  Future<List<ExpedicaoSeparadoItemConsultaModel>> _findSeparado() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', carrinhoPercurso.codEmpresa)
          .equals('Origem', carrinhoPercurso.origem)
          .equals('CodSepararEstoque', carrinhoPercurso.codOrigem)
          .equals('Situacao', ExpedicaoSituacaoModel.separado);

      final itens =
          await conferirItemConsultaSeparacaoRepository.select(queryBuilder);

      if (itens.isEmpty) {
        throw AppError('Nenhum item encontrado');
      }

      return itens;
    } catch (e) {
      if (e is AppError) rethrow;
      throw Exception('Erro ao buscar itens separados: $e');
    }
  }

  ExpedicaoConferirModel _createConferir(
    ExpedicaoSeparadoItemConsultaModel item,
  ) {
    return ExpedicaoConferirModel(
      codEmpresa: item.codEmpresa,
      codConferir: 0,
      origem: ExpedicaoOrigemModel.separacao,
      codOrigem: item.codSepararEstoque,
      codPrioridade: item.codPrioridade,
      situacao: ExpedicaoSituacaoModel.aguardando,
      data: DateTime.now(),
      hora: DateTime.now().toString().substring(11, 19),
      historico: item.historico,
      observacao: item.observacao,
    );
  }

  List<ExpedicaoConferirItemModel> _createItensConferir(
    ExpedicaoConferirModel conferir,
    List<ExpedicaoSeparadoItemConsultaModel> itens,
  ) {
    final newItens = <ExpedicaoConferirItemModel>[];

    for (var el in itens) {
      final newItem = ExpedicaoConferirItemModel(
        codEmpresa: conferir.codEmpresa,
        codConferir: conferir.codConferir,
        item: '00000',
        codCarrinhoPercurso: el.codCarrinhoPercurso,
        itemCarrinhoPercurso: el.itemCarrinhoPercurso,
        codProduto: el.codProduto,
        codUnidadeMedida: el.codUnidadeMedida,
        quantidade: el.quantidadeSeparacao,
        quantidadeConferida: 0.00,
      );

      newItens.add(newItem);
    }

    return newItens;
  }
}
