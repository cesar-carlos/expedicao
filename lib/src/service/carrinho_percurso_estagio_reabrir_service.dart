import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';

class CarrinhoPercursoEstagioReabrirService {
  final ExpedicaoCarrinhoPercursoEstagioModel carrinhoPercursoEstagio;
  final ExpedicaoCarrinhoModel carrinho;

  CarrinhoPercursoEstagioReabrirService({
    required this.carrinhoPercursoEstagio,
    required this.carrinho,
  });

  Future<void> execute() async {
    await CarrinhoRepository().update(carrinho);
    await CarrinhoPercursoEstagioRepository().update(
      carrinhoPercursoEstagio.reabrir(),
    );
  }
}
