import 'socket_mutation_action.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_repository.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_error_alert.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class ConferirFinalizarService {
  final int codEmpresa;
  final int codConferir;

  final conferirRepository = ConferirRepository();
  final carrinhoPercursoRepository = CarrinhoPercursoRepository();
  final conferirConsultaRepository = ConferirConsultaRepository();

  ConferirFinalizarService({
    required this.codEmpresa,
    required this.codConferir,
  });

  Future<void> execute() async {
    return runSocketMutation(() async {
      try {
        final conferirsConsulta = await _getConferirConsulta();
        final conferirs = await _getConferir();

        if (conferirsConsulta.isEmpty) {
          throw AppErrorAlert('Conferência não encontrada');
        }

        final conferir = conferirs.first;
        final conferirConsulta = conferirsConsulta.first;

        final carrinhoPercurso = await _getCarrinhoPercurso(
          conferirConsulta.codCarrinhoPercurso,
        );

        final conferirFinalizada = conferir.copyWith(
          situacao: ExpedicaoSituacaoModel.conferido,
        );
        final carrinhoPercursoFinalizado = carrinhoPercurso.first.copyWith(
          situacao: ExpedicaoSituacaoModel.conferido,
        );

        await conferirRepository.update(conferirFinalizada);
        await carrinhoPercursoRepository.update(carrinhoPercursoFinalizado);
      } catch (e) {
        if (e is AppErrorAlert) rethrow;
        throw AppError.fromUnknown(e);
      }
    });
  }

  Future<List> _getConferirConsulta() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodConferir', codConferir);

      return await conferirConsultaRepository.select(queryBuilder);
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<List> _getConferir() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodConferir', codConferir);

      return await conferirRepository.select(queryBuilder);
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<List> _getCarrinhoPercurso(int codCarrinhoPercurso) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodCarrinhoPercurso', codCarrinhoPercurso);

      return await carrinhoPercursoRepository.select(queryBuilder);
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }
}
