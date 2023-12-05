import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';

class CarrinhoPercursoEstagioFinalizarService {
  final _processo = Get.find<ProcessoExecutavelModel>();

  final ExpedicaoCarrinhoModel carrinho;
  final ExpedicaoCarrinhoPercursoModel carrinhoPercurso;
  final ExpedicaoPercursoEstagioModel carrinhoPercursoEstagio;

  CarrinhoPercursoEstagioFinalizarService({
    required this.carrinho,
    required this.carrinhoPercurso,
    required this.carrinhoPercursoEstagio,
  });

  Future<void> execute() async {
    final currentEstado = carrinhoPercursoEstagio.copyWith(
      situacao: ExpedicaoSituacaoModel.finalizada,
      dataFinalizacao: DateTime.now(),
      horaFinalizacao: DateTime.now().toString().substring(11, 19),
      codUsuarioFinalizacao: _processo.codUsuario,
      nomeUsuarioFinalizacao: _processo.nomeUsuario,
    );

    await CarrinhoRepository().update(carrinho);
    await CarrinhoPercursoEstagioRepository().update(currentEstado);
  }
}
