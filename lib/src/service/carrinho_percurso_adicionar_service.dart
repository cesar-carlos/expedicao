import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_model.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';

class CarrinhoPercursoAdicionarService {
  final ExpedicaoCarrinhoModel carrinho;
  final ExpedicaoCarrinhoPercursoModel carrinhoPercurso;
  final ExpedicaoPercursoEstagio percursoEstagio;
  final ProcessoExecutavelModel processo;

  CarrinhoPercursoAdicionarService({
    required this.carrinho,
    required this.carrinhoPercurso,
    required this.percursoEstagio,
    required this.processo,
  });

  Future<ExpedicaoPercursoEstagioModel?> execute() async {
    final newCarrinho = carrinho.copyWith(
      situacao: ExpedicaoCarrinhoSituacaoModel.emUso,
    );

    await CarrinhoRepository().update(newCarrinho);

    final carrinhoPercursoEstagio = await CarrinhoPercursoEstagioRepository()
        .insert(_createPercursoEstagio());

    if (carrinhoPercursoEstagio.isNotEmpty) {
      return carrinhoPercursoEstagio.first;
    }

    return null;
  }

  ExpedicaoPercursoEstagioModel _createPercursoEstagio() {
    return ExpedicaoPercursoEstagioModel(
      codEmpresa: carrinhoPercurso.codEmpresa,
      codCarrinhoPercurso: carrinhoPercurso.codCarrinhoPercurso,
      item: '',
      codPercursoEstagio: percursoEstagio.codPercursoEstagio,
      codCarrinho: carrinho.codCarrinho,
      situacao: ExpedicaoSituacaoModel.emAndamento,
      dataInicio: DateTime.now(),
      horaInicio: DateTime.now().toString().substring(11, 19),
      codUsuario: processo.codUsuario,
      nomeUsuario: processo.nomeUsuario,
    );
  }
}
