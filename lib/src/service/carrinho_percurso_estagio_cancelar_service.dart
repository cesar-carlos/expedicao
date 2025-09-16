import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_model.dart';
import 'package:app_expedicao/src/repository/expedicao_cancelamento/cancelamento_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/model/expedicao_cancelamento_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';

class CarrinhoPercursoEstagioCancelarService {
  final _processo = Get.find<ProcessoExecutavelModel>();

  final ExpedicaoCarrinhoModel carrinho;
  final cancelamentoRepository = CancelamentoRepository();
  final ExpedicaoCarrinhoPercursoEstagioModel percursoEstagio;
  final carrinhoPercursoEstagioRepository = CarrinhoPercursoEstagioRepository();
  final carrinhoRepository = CarrinhoRepository();

  CarrinhoPercursoEstagioCancelarService({
    required this.carrinho,
    required this.percursoEstagio,
  });

  Future<void> execute() async {
    try {
      final newPercursoEstagio = percursoEstagio.copyWith(
        situacao: ExpedicaoSituacaoModel.cancelada,
      );

      final newCancelamento = await _createCancelamento();

      await cancelamentoRepository.insert(newCancelamento);
      await carrinhoPercursoEstagioRepository.update(newPercursoEstagio);
      await carrinhoRepository.update(carrinho);
    } catch (e) {
      throw Exception('Erro ao cancelar carrinho de percurso estágio: $e');
    }
  }

  Future<ExpedicaoCancelamentoModel> _createCancelamento() async {
    try {
      return ExpedicaoCancelamentoModel(
        codEmpresa: percursoEstagio.codEmpresa,
        codCancelamento: 0,
        origem: ExpedicaoOrigemModel.carrinhoPercurso,
        codOrigem: percursoEstagio.codCarrinhoPercurso,
        itemOrigem: percursoEstagio.item,
        codMotivoCancelamento: 1,
        dataCancelamento: DateTime.now(),
        horaCancelamento: DateTime.now().toIso8601String().substring(11, 19),
        codUsuarioCancelamento: _processo.codUsuario,
        nomeUsuarioCancelamento: _processo.nomeUsuario,
        observacaoCancelamento: null,
      );
    } catch (e) {
      throw Exception('Erro ao criar registro de cancelamento: $e');
    }
  }
}
