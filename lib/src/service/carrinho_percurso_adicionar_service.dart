import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';

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

  Future<void> execute() async {
    final newCarrinho = carrinho.copyWith(situacao: 'AB');
    await CarrinhoRepository().update(newCarrinho);
    await CarrinhoPercursoEstagioRepository().insert(_createPercursoEstagio());
  }

  ExpedicaoPercursoEstagioModel _createPercursoEstagio() {
    return ExpedicaoPercursoEstagioModel(
      codEmpresa: carrinhoPercurso.codEmpresa,
      codCarrinhoPercurso: carrinhoPercurso.codCarrinhoPercurso,
      codPercursoEstagio: percursoEstagio.codPercursoEstagio,
      codCarrinho: carrinho.codCarrinho,
      situacao: 'AB',
      dataInicio: DateTime.now(),
      horaInicio: DateTime.now().toString().substring(11, 19),
      codUsuario: processo.codUsuario,
      nomeUsuario: processo.nomeUsuario,
    );
  }
}
