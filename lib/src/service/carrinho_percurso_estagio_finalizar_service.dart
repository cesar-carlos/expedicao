import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';

class CarrinhoPercursoEstagioFinalizarService {
  final _processo = Get.find<ProcessoExecutavelModel>();

  final ExpedicaoPercursoEstagioModel carrinhoPercursoEstagio;
  final ExpedicaoCarrinhoModel carrinho;

  CarrinhoPercursoEstagioFinalizarService({
    required this.carrinhoPercursoEstagio,
    required this.carrinho,
  });

  Future<void> execute() async {
    final newEstagio = carrinhoPercursoEstagio.copyWith(
      dataFinalizacao: DateTime.now(),
      horaFinalizacao: DateTime.now().toString().substring(11, 19),
      codUsuarioFinalizacao: _processo.codUsuario,
      nomeUsuarioFinalizacao: _processo.nomeUsuario,
    );

    await CarrinhoRepository().update(carrinho);
    await CarrinhoPercursoEstagioRepository().update(newEstagio);
  }
}
