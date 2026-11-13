import 'socket_mutation_action.dart';
import 'carrinho_recovery_validation.dart';
import '../model/expedicao_carrinho_percurso_estagio_model.dart';

import 'package:get/get.dart';
import 'package:app_expedicao/src/app/app_error_alert.dart';
import 'package:app_expedicao/src/app/app_helper.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_model.dart';
import 'package:app_expedicao/src/repository/expedicao_cancelamento/cancelamento_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso_agrupamento/carrinho_percurso_agrupamento_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso_agrupamento/carrinho_percurso_agrupamento_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/model/expedicao_cancelamento_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class CarrinhoPercursoEstagioAgruparService {
  final int codEmpresa;
  final int codCarrinhoPercurso;

  final _processo = Get.find<ProcessoExecutavelModel>();

  final carrinhoPercursoAgrupamentoRepository =
      CarrinhoPercursoAgrupamentoRepository();
  final cancelamentoRepository = CancelamentoRepository();
  final carrinhoPercursoEstagioRepository = CarrinhoPercursoEstagioRepository();
  final carrinhoRepository = CarrinhoRepository();
  final carrinhoPercursoAgrupamentoConsultaRepository =
      CarrinhoPercursoAgrupamentoConsultaRepository();

  CarrinhoPercursoEstagioAgruparService({
    required this.codEmpresa,
    required this.codCarrinhoPercurso,
  });

  void _checkContext(ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel row) {
    if (row.codEmpresa != codEmpresa ||
        row.codCarrinhoPercurso != codCarrinhoPercurso ||
        row.origem != 'CO') {
      throw AppErrorAlert(
        'O carrinho não pertence ao percurso de conferência desta operação.',
      );
    }
  }

  Future<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel> refreshDestination(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel row,
  ) => _fresh(row);

  Future<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel> _fresh(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel row,
  ) async {
    _checkContext(row);
    final rows = await carrinhoPercursoAgrupamentoConsultaRepository.select(
      QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodCarrinhoPercurso', codCarrinhoPercurso)
          .equals('Origem', row.origem)
          .equals('CodOrigem', row.codOrigem)
          .equals('CodCarrinho', row.codCarrinho)
          .equals(
            'ItemCarrinhoPercurso',
            AppHelper.itemSequenceKey(row.itemCarrinhoPercurso),
          )
          .allRows(orderField: 'ItemCarrinhoPercurso'),
    );
    if (rows.length != 1) {
      throw AppErrorAlert(
        'Carrinho ou vínculo de agrupamento ausente ou ambíguo. Atualize os dados.',
      );
    }
    return rows.single;
  }

  Future<ExpedicaoCarrinhoPercursoEstagioModel> _currentStage(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel row,
    String expected,
  ) async {
    final rows = await carrinhoPercursoEstagioRepository.select(
      QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodCarrinhoPercurso', codCarrinhoPercurso)
          .equals('Item', AppHelper.itemSequenceKey(row.itemCarrinhoPercurso))
          .equals('CodCarrinho', row.codCarrinho)
          .equals('Origem', 'CO')
          .equals('CodOrigem', row.codOrigem),
    );
    if (rows.length != 1 || rows.single.situacao != expected) {
      throw AppErrorAlert(
        'O estágio do carrinho mudou ou a operação está parcialmente gravada. Atualize os dados.',
      );
    }
    await CarrinhoRecoveryValidation.assertLatestStage(rows.single);
    return rows.single;
  }

  Future<void> _checkDestination(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel row,
  ) async {
    if (row.situacao != ExpedicaoSituacaoModel.conferido ||
        row.codCarrinhoAgrupador != null ||
        (row.itemAgrupamento?.trim().isNotEmpty ?? false)) {
      throw AppErrorAlert('O destino precisa estar CONFERIDO.');
    }
    await _currentStage(row, ExpedicaoSituacaoModel.conferido);
    final carts = await carrinhoRepository.select(
      QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodCarrinho', row.codCarrinho),
    );
    if (carts.length != 1 ||
        carts.single.situacao != ExpedicaoCarrinhoSituacaoModel.conferido) {
      throw AppErrorAlert('O cadastro do destino não está CONFERIDO.');
    }
  }

  static Future<List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>>
  consulta([QueryBuilder? queryBuilder]) async {
    try {
      return await CarrinhoPercursoAgrupamentoConsultaRepository().select(
        (queryBuilder ?? QueryBuilder()).withAllRows(
          orderField: 'ItemCarrinhoPercurso',
        ),
      );
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel?> carrinhoPercurso(
    String itemCarrinhoPercurso,
  ) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodCarrinhoPercurso', codCarrinhoPercurso)
          .equals(
            'ItemCarrinhoPercurso',
            AppHelper.itemSequenceKey(itemCarrinhoPercurso),
          );

      final result = await carrinhoPercursoAgrupamentoConsultaRepository.select(
        queryBuilder,
      );

      if (result.isEmpty) return null;
      return result.first;
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>>
  carrinhosPercurso(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupador,
  ) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', carrinhoAgrupador.codEmpresa)
          .equals('CodCarrinhoPercurso', carrinhoAgrupador.codCarrinhoPercurso)
          .equals('Origem', carrinhoAgrupador.origem)
          .equals('CodOrigem', carrinhoAgrupador.codOrigem)
          .notEquals('CodCarrinho', carrinhoAgrupador.codCarrinho)
          .notEquals('Situacao', ExpedicaoSituacaoModel.cancelada)
          .allRows(orderField: 'ItemCarrinhoPercurso');

      final result = await carrinhoPercursoAgrupamentoConsultaRepository.select(
        queryBuilder,
      );
      return result;
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<void> agruparCarrinho(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupador,
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupar,
  ) async {
    return runSocketMutation(() async {
      try {
        _checkContext(carrinhoAgrupador);
        _checkContext(carrinhoAgrupar);
        if (carrinhoAgrupador.codOrigem != carrinhoAgrupar.codOrigem) {
          throw AppErrorAlert(
            'Os carrinhos devem pertencer à mesma conferência.',
          );
        }
        carrinhoAgrupador = await _fresh(carrinhoAgrupador);
        carrinhoAgrupar = await _fresh(carrinhoAgrupar);
        await _checkDestination(carrinhoAgrupador);
        if (carrinhoAgrupar.codCarrinho == carrinhoAgrupador.codCarrinho) {
          throw AppErrorAlert('Não é possível agrupar o carrinho em si mesmo');
        }

        if (carrinhoAgrupar.carrinhoAgrupador == 'S') {
          throw AppErrorAlert(
            'Carrinho agrupador não pode ser agrupado em outro',
          );
        }
        if (carrinhoAgrupar.codCarrinhoAgrupador != null ||
            (carrinhoAgrupar.itemAgrupamento?.trim().isNotEmpty ?? false)) {
          throw AppErrorAlert(
            'O carrinho já possui vínculo ativo de agrupamento.',
          );
        }

        if (carrinhoAgrupar.situacao != ExpedicaoSituacaoModel.conferido) {
          throw AppErrorAlert(
            'Não é possível agrupar um carrinho que esteja ${carrinhoAgrupar.situacao}',
          );
        }

        final itemCarrinhoPercurso = AppHelper.itemSequenceKey(
          carrinhoAgrupar.itemCarrinhoPercurso,
        );

        final agrupado = ExpedicaoCarrinhoPercursoAgrupamentoModel(
          codEmpresa: carrinhoAgrupar.codEmpresa,
          codCarrinhoPercurso: carrinhoAgrupar.codCarrinhoPercurso,
          item: AppHelper.itemSequenceKey(''),
          origem: carrinhoAgrupar.origem,
          itemCarrinhoPercurso: itemCarrinhoPercurso,
          situacao: ExpedicaoSituacaoModel.agrupado,
          codCarrinhoAgrupador: carrinhoAgrupador.codCarrinho,
          dataLancamento: DateTime.now(),
          horaLancamento: DateTime.now().toIso8601String().substring(11, 19),
          codUsuarioLancamento: _processo.codUsuario,
          nomeUsuarioLancamento: _processo.nomeUsuario,
        );

        final carrinhoQueryBuilder = QueryBuilder()
            .equals('CodEmpresa', carrinhoAgrupar.codEmpresa)
            .equals('CodCarrinho', carrinhoAgrupar.codCarrinho);

        final carrinho = await carrinhoRepository.select(carrinhoQueryBuilder);

        if (carrinho.length != 1 ||
            carrinho.single.situacao !=
                ExpedicaoCarrinhoSituacaoModel.conferido) {
          throw AppErrorAlert(
            'O cadastro do carrinho a agrupar não está CONFERIDO.',
          );
        }

        final newCarrinho = carrinho.first.copyWith(
          situacao: ExpedicaoCarrinhoSituacaoModel.liberado,
        );

        final currentStage = await _currentStage(
          carrinhoAgrupar,
          ExpedicaoSituacaoModel.conferido,
        );
        final percursoEstagio = currentStage.copyWith(
          situacao: ExpedicaoSituacaoModel.agrupado,
        );

        await carrinhoRepository.update(newCarrinho);
        await carrinhoPercursoEstagioRepository.update(percursoEstagio);
        await carrinhoPercursoAgrupamentoRepository.insert(agrupado);
      } catch (e) {
        if (e is AppErrorAlert) rethrow;
        throw AppError.fromUnknown(e);
      }
    });
  }

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>>
  agruparTodosCarrinho(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupador,
  ) async {
    return runSocketMutation(() async {
      try {
        _checkContext(carrinhoAgrupador);
        final queryBuilder = QueryBuilder()
            .equals('CodEmpresa', carrinhoAgrupador.codEmpresa)
            .equals(
              'CodCarrinhoPercurso',
              carrinhoAgrupador.codCarrinhoPercurso,
            )
            .equals('Origem', carrinhoAgrupador.origem)
            .equals('CodOrigem', carrinhoAgrupador.codOrigem)
            .notEquals('CodCarrinho', carrinhoAgrupador.codCarrinho)
            .equals('CarrinhoAgrupador', 'N')
            .equals('Situacao', ExpedicaoSituacaoModel.conferido)
            .allRows(orderField: 'ItemCarrinhoPercurso');

        final carrinhoPercursoAgrupamentoConsulta =
            await carrinhoPercursoAgrupamentoConsultaRepository.select(
              queryBuilder,
            );

        if (carrinhoPercursoAgrupamentoConsulta.isEmpty) {
          throw AppErrorAlert('Não há carrinhos para agrupar');
        }

        for (final carrinhoAgrupar in carrinhoPercursoAgrupamentoConsulta) {
          await agruparCarrinho(carrinhoAgrupador, carrinhoAgrupar);
        }

        final newQueryBuilder = QueryBuilder()
            .equals('CodEmpresa', carrinhoAgrupador.codEmpresa)
            .equals(
              'CodCarrinhoPercurso',
              carrinhoAgrupador.codCarrinhoPercurso,
            )
            .equals('Origem', carrinhoAgrupador.origem)
            .equals('CodOrigem', carrinhoAgrupador.codOrigem)
            .notEquals('CodCarrinho', carrinhoAgrupador.codCarrinho)
            .equals('Situacao', ExpedicaoSituacaoModel.agrupado)
            .equals('CodCarrinhoAgrupador', carrinhoAgrupador.codCarrinho)
            .allRows(orderField: 'ItemCarrinhoPercurso');

        return await carrinhoPercursoAgrupamentoConsultaRepository.select(
          newQueryBuilder,
        );
      } catch (e) {
        if (e is AppErrorAlert) rethrow;
        throw AppError.fromUnknown(e);
      }
    });
  }

  Future<void> cancelarAgrupamento(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupado,
  ) async {
    return runSocketMutation(() async {
      try {
        final original = carrinhoAgrupado;
        carrinhoAgrupado = await _fresh(carrinhoAgrupado);
        if (!AppHelper.sameGridItem(
              original.itemAgrupamento,
              carrinhoAgrupado.itemAgrupamento,
            ) ||
            original.codCarrinhoAgrupador !=
                carrinhoAgrupado.codCarrinhoAgrupador) {
          throw AppErrorAlert(
            'O vínculo de agrupamento mudou. Atualize os dados.',
          );
        }
        if (carrinhoAgrupado.situacao != ExpedicaoSituacaoModel.agrupado) {
          throw AppErrorAlert(
            'Não é possível desagrupar um carrinho que esteja ${carrinhoAgrupado.situacao}',
          );
        }

        final itemAgrupamento = carrinhoAgrupado.itemAgrupamento;
        if (itemAgrupamento == null || itemAgrupamento.trim().isEmpty) {
          throw AppErrorAlert('Agrupamento não encontrado');
        }
        if (carrinhoAgrupado.codCarrinhoAgrupador == null ||
            carrinhoAgrupado.codCarrinhoAgrupador! <= 0) {
          throw AppErrorAlert('Destino do agrupamento não informado.');
        }
        final destinations = await carrinhoPercursoAgrupamentoConsultaRepository
            .select(
              QueryBuilder()
                  .equals('CodEmpresa', codEmpresa)
                  .equals('CodCarrinhoPercurso', codCarrinhoPercurso)
                  .equals('Origem', 'CO')
                  .equals('CodOrigem', carrinhoAgrupado.codOrigem)
                  .equals('CodCarrinho', carrinhoAgrupado.codCarrinhoAgrupador)
                  .equals('Situacao', ExpedicaoSituacaoModel.conferido)
                  .allRows(orderField: 'ItemCarrinhoPercurso'),
            );
        if (destinations.length != 1) {
          throw AppErrorAlert('Destino do agrupamento ausente ou ambíguo.');
        }
        await _checkDestination(destinations.single);

        final carrinhoQueryBuilder = QueryBuilder()
            .equals('CodEmpresa', carrinhoAgrupado.codEmpresa)
            .equals('CodCarrinho', carrinhoAgrupado.codCarrinho);

        final carrinhos = await carrinhoRepository.select(carrinhoQueryBuilder);

        if (carrinhos.isEmpty) {
          throw AppErrorAlert('Carrinho não encontrado');
        }

        if (carrinhos.first.situacao !=
            ExpedicaoCarrinhoSituacaoModel.liberado) {
          throw AppErrorAlert(
            'Carrinho não removido',
            details:
                'Carrinho não está liberado para cancelamento!. Situacao: ${carrinhos.first.situacao}',
          );
        }

        final newCarrinho = carrinhos.first.copyWith(
          situacao: ExpedicaoCarrinhoSituacaoModel.conferido,
        );

        final agrupadosQueryBuilder = QueryBuilder()
            .equals('CodEmpresa', carrinhoAgrupado.codEmpresa)
            .equals('CodCarrinhoPercurso', carrinhoAgrupado.codCarrinhoPercurso)
            .equals('Item', AppHelper.itemSequenceKey(itemAgrupamento));

        final agrupados = await carrinhoPercursoAgrupamentoRepository.select(
          agrupadosQueryBuilder,
        );

        if (agrupados.length != 1 ||
            agrupados.single.situacao != ExpedicaoSituacaoModel.agrupado ||
            agrupados.single.origem != 'CO' ||
            !AppHelper.sameGridItem(
              agrupados.single.itemCarrinhoPercurso,
              carrinhoAgrupado.itemCarrinhoPercurso,
            ) ||
            agrupados.single.codCarrinhoAgrupador !=
                carrinhoAgrupado.codCarrinhoAgrupador) {
          throw AppErrorAlert(
            'O vínculo ativo não corresponde ao carrinho e destino selecionados.',
          );
        }

        final currentStage = await _currentStage(
          carrinhoAgrupado,
          ExpedicaoSituacaoModel.agrupado,
        );
        final percursoEstagio = currentStage.copyWith(
          situacao: ExpedicaoSituacaoModel.conferido,
        );

        final agrupadoCancelar = agrupados.first.copyWith(
          situacao: ExpedicaoSituacaoModel.cancelada,
        );

        final cancelamento = ExpedicaoCancelamentoModel(
          codEmpresa: agrupadoCancelar.codEmpresa,
          codCancelamento: 0,
          origem: ExpedicaoOrigemModel.agrupado,
          codOrigem: agrupadoCancelar.codCarrinhoPercurso,
          itemOrigem: agrupadoCancelar.item,
          dataCancelamento: DateTime.now(),
          horaCancelamento: DateTime.now().toIso8601String().substring(11, 19),
          codUsuarioCancelamento: _processo.codUsuario,
          nomeUsuarioCancelamento: _processo.nomeUsuario,
        );

        await carrinhoPercursoEstagioRepository.update(percursoEstagio);
        await carrinhoPercursoAgrupamentoRepository.update(agrupadoCancelar);
        await cancelamentoRepository.insert(cancelamento);
        await carrinhoRepository.update(newCarrinho);
      } catch (e) {
        if (e is AppErrorAlert) rethrow;
        throw AppError.fromUnknown(e);
      }
    });
  }

  Future<List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>>
  cancelarTodosAgrupamento(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupador,
  ) async {
    return runSocketMutation(() async {
      try {
        _checkContext(carrinhoAgrupador);
        final queryBuilder = QueryBuilder()
            .equals('CodEmpresa', carrinhoAgrupador.codEmpresa)
            .equals(
              'CodCarrinhoPercurso',
              carrinhoAgrupador.codCarrinhoPercurso,
            )
            .equals('Origem', carrinhoAgrupador.origem)
            .equals('CodOrigem', carrinhoAgrupador.codOrigem)
            .notEquals('CodCarrinho', carrinhoAgrupador.codCarrinho)
            .equals('Situacao', ExpedicaoSituacaoModel.agrupado)
            .equals('CodCarrinhoAgrupador', carrinhoAgrupador.codCarrinho)
            .allRows(orderField: 'ItemCarrinhoPercurso');

        final carrinhoPercursoAgrupamentoConsulta =
            await carrinhoPercursoAgrupamentoConsultaRepository.select(
              queryBuilder,
            );

        if (carrinhoPercursoAgrupamentoConsulta.isEmpty) {
          throw AppErrorAlert('Não há carrinhos para cancelar agrupamento');
        }

        for (final carrinhoAgrupar in carrinhoPercursoAgrupamentoConsulta) {
          await cancelarAgrupamento(carrinhoAgrupar);
        }

        final basicQueryBuilder = QueryBuilder()
            .equals('CodEmpresa', carrinhoAgrupador.codEmpresa)
            .equals(
              'CodCarrinhoPercurso',
              carrinhoAgrupador.codCarrinhoPercurso,
            )
            .equals('Origem', carrinhoAgrupador.origem)
            .equals('CodOrigem', carrinhoAgrupador.codOrigem)
            .notEquals('CodCarrinho', carrinhoAgrupador.codCarrinho)
            .equals('Situacao', ExpedicaoSituacaoModel.conferido)
            .allRows(orderField: 'ItemCarrinhoPercurso');

        return await carrinhoPercursoAgrupamentoConsultaRepository.select(
          basicQueryBuilder,
        );
      } catch (e) {
        if (e is AppErrorAlert) rethrow;
        throw AppError.fromUnknown(e);
      }
    });
  }
}
