import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_separacao_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_consulta_separacao_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separar/separar_repository.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_model.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/app/app_error_code.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class ConferirSeparacaoAdicionarService {
  //final _processo = Get.find<ProcessoExecutavelModel>();

  final ExpedicaoCarrinhoPercursoModel carrinhoPercurso;
  late List<ExpedicaoConferirItemSeparacaoConsultaModel>
      _conferirItensSeparacaoConsulta;

  ConferirSeparacaoAdicionarService({required this.carrinhoPercurso});

  _build() async {
    final params = '''
        CodEmpresa = ${carrinhoPercurso.codEmpresa}
      AND CodSepararEstoque = ${carrinhoPercurso.codOrigem}
      AND CodCarrinhoPercurso = ${carrinhoPercurso.codCarrinhoPercurso}
      AND Situacao = '${ExpedicaoSituacaoModel.separando}'
   
    ''';

    final result =
        await ConferirItemConsultaSeparacaoRepository().select(params);

    if (result.isEmpty) {
      throw throw AppError(
        AppErrorCode.separarEstagioNaoEncontrado,
        'conferir separacao item consulta, não encontrado',
      );
    }

    _conferirItensSeparacaoConsulta = result;
  }

  Future<void> execute() async {
    await _build();

    final conferir =
        await _createConferir(_conferirItensSeparacaoConsulta.first);
    final newConferirs = await ConferirRepository().insert(conferir);

    if (newConferirs.isEmpty) {
      throw AppError(
        AppErrorCode.erroCriarExpedicaoConferir,
        'erro tenta criar (Expedicao.Conferir)',
      );
    }

    final newItensConferir = _createItensConferir(
      newConferirs.first,
      _conferirItensSeparacaoConsulta,
    );

    await ConferirItemRepository().insertAll(newItensConferir);
  }

  Future<ExpedicaoConferirModel> _createConferir(
    ExpedicaoConferirItemSeparacaoConsultaModel item,
  ) async {
    final separar = await SepararRepository().select('''
        CodEmpresa = ${item.codEmpresa}
      AND CodSepararEstoque = ${item.codSepararEstoque}
    ''');

    return ExpedicaoConferirModel(
      codEmpresa: item.codEmpresa,
      codConferir: 0,
      origem: ExpedicaoOrigemModel.separacao,
      codOrigem: item.codSepararEstoque,
      codPrioridade: item.codPrioridade,
      situacao: ExpedicaoSituacaoModel.aguardando,
      data: DateTime.now(),
      hora: DateTime.now().toString().substring(11, 19),
      historico: separar.last.historico,
      observacao: separar.last.observacao,
    );
  }

  List<ExpedicaoConferirItemModel> _createItensConferir(
    ExpedicaoConferirModel conferir,
    List<ExpedicaoConferirItemSeparacaoConsultaModel> itens,
  ) {
    final newItens = <ExpedicaoConferirItemModel>[];

    for (var el in itens) {
      final newItem = ExpedicaoConferirItemModel(
        codEmpresa: el.codEmpresa,
        codConferir: conferir.codConferir,
        item: '',
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
