import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';

class AdicionarCarrinhoPercursoService {
  final ExpedicaoCarrinhoModel carrinho;
  final ExpedicaoCarrinhoPercursoModel percurso;
  final ExpedicaoPercursoEstagio estagio;
  final ProcessoExecutavelModel processo;

  AdicionarCarrinhoPercursoService({
    required this.carrinho,
    required this.percurso,
    required this.estagio,
    required this.processo,
  });

  execute() async {
    final newCarrinho = carrinho.copyWith(situacao: 'AB');
    CarrinhoRepository().update(newCarrinho);
    CarrinhoPercursoEstagioRepository().insert(_percursoEstagio());
  }

  ExpedicaoPercursoEstagioModel _percursoEstagio() {
    return ExpedicaoPercursoEstagioModel(
      codEmpresa: percurso.codEmpresa,
      codCarrinhoPercurso: percurso.codCarrinhoPercurso,
      codPercursoEstagio: estagio.codPercursoEstagio,
      codCarrinho: carrinho.codCarrinho,
      situacao: 'AB',
      dataInicio: DateTime.now(),
      horaInicio: DateTime.now().toString().substring(11, 19),
      codUsuario: processo.codUsuario,
      nomeUsuario: processo.nomeUsuario,
    );
  }
}
