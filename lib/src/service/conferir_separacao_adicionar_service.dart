import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_separacao_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_consulta_separacao_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_repository.dart';
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

  Future<void> execute() async {
    await _findSeparacao();

    final conferir = _createConferir(_conferirItensSeparacaoConsulta.first);
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

  _findSeparacao() async {
    final params = '''
        CodEmpresa = ${carrinhoPercurso.codEmpresa}
      AND Origem = '${carrinhoPercurso.origem}'
      AND CodSepararEstoque = ${carrinhoPercurso.codOrigem}
      AND Situacao = '${ExpedicaoSituacaoModel.separado}'

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

  ExpedicaoConferirModel _createConferir(
    ExpedicaoConferirItemSeparacaoConsultaModel item,
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
    List<ExpedicaoConferirItemSeparacaoConsultaModel> itens,
  ) {
    int sequence = 0;
    final newItens = <ExpedicaoConferirItemModel>[];

    for (var el in itens) {
      sequence++;
      final item = sequence.toString().padLeft(5, '0');

      final newItem = ExpedicaoConferirItemModel(
        codEmpresa: conferir.codEmpresa,
        codConferir: conferir.codConferir,
        item: item,
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
