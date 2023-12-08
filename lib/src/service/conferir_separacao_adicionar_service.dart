import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_error_code.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separar/separar_repository.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_model.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';

class ConferirSeparacaoAdicionarService {
  final _processo = Get.find<ProcessoExecutavelModel>();
  final ExpedicaoCarrinhoPercursoModel carrinhoPercurso;
  late ExpedicaoSepararModel _separar;

  ConferirSeparacaoAdicionarService({required this.carrinhoPercurso}) {
    _build();
  }

  _build() async {
    final result = await SepararRepository().select('''
        CodEmpresa = ${carrinhoPercurso.codEmpresa}
      AND CodSeparar = ${carrinhoPercurso.codOrigem}
      AND Situacao <> '${ExpedicaoSituacaoModel.cancelada}'
   
    ''');

    if (result.isEmpty) {
      throw throw AppError(
        AppErrorCode.separarEstagioNaoEncontrado,
        'Separar Estagio não encontrado',
      );
    }

    _separar = result.first;
  }

  Future<void> execute() async {}

  Future<ExpedicaoConferirModel> _createConferir() async {
    return ExpedicaoConferirModel(
      codEmpresa: _processo.codEmpresa,
      codConferir: _separar.codPrioridade,
      origem: ExpedicaoOrigemModel.separacao,
      codOrigem: _separar.codSepararEstoque,
      codPrioridade: _separar.codPrioridade,
      situacao: ExpedicaoSituacaoModel.aguardando,
      data: DateTime.now(),
      hora: DateTime.now().toString(),
    );
  }
}
