import '../app/app_error.dart';

import 'package:get/get.dart';

import '../app/app_socket_config.dart';
import '../app/app_helper.dart';
import '../model/pagination/query_builder.dart';
import '../model/expedicao_carrinho_percurso_estagio_model.dart';
import '../repository/expedicao_carrinhos/carrinho_repository.dart';
import '../repository/expedicao_carrinho_percurso_agrupamento/carrinho_percurso_agrupamento_repository.dart';
import '../model/expedicao_carrinho_percurso_agrupamento_model.dart';
import '../repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import '../repository/expedicao_separacao_item/separacao_item_repository.dart';
import '../repository/expedicao_conferencia_item/conferencia_item_repository.dart';

typedef CarrinhoRecoveryStage = ({int percurso, String item, String situacao});
typedef CarrinhoRecoveryItem = ({
  int percurso,
  String estagio,
  String situacao,
});

class CarrinhoRecoveryValidation {
  static Future<void> assertLatestStage(
    ExpedicaoCarrinhoPercursoEstagioModel stage,
  ) async {
    final history = await CarrinhoPercursoEstagioRepository().select(
      QueryBuilder()
          .equals('CodEmpresa', stage.codEmpresa)
          .equals('CodCarrinho', stage.codCarrinho)
          .allRows(orderField: 'CodCarrinhoPercurso', thenBy: ['Item']),
    );
    final current = _latestStages(history)[stage.codCarrinho];
    if (current == null ||
        current.codCarrinhoPercurso != stage.codCarrinhoPercurso ||
        !AppHelper.sameGridItem(current.item, stage.item) ||
        current.origem != stage.origem ||
        current.codOrigem != stage.codOrigem) {
      Get.find<AppSocketConfig>().recovery.invalidate();
      throw AppError(
        'O carrinho já mudou de estágio ou documento. Recarregue os dados; esta ação não pode alterar seu cadastro atual.',
      );
    }
  }

  static Future<void> reloadAndValidate({
    required int codEmpresa,
    required int codDocumento,
    required bool conferencia,
  }) async {
    final stages = await CarrinhoPercursoEstagioRepository().select(
      QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('Origem', conferencia ? 'CO' : 'SE')
          .equals('CodOrigem', codDocumento)
          .allRows(orderField: 'CodCarrinhoPercurso', thenBy: ['Item']),
    );
    final query = QueryBuilder()
        .equals('CodEmpresa', codEmpresa)
        .equals(conferencia ? 'CodConferir' : 'CodSepararEstoque', codDocumento)
        .allRows();
    final List<CarrinhoRecoveryItem> items;
    if (conferencia) {
      items = (await ConferenciaItemRepository().select(query))
          .map(
            (item) => (
              percurso: item.codCarrinhoPercurso,
              estagio: item.itemCarrinhoPercurso,
              situacao: item.situacao,
            ),
          )
          .toList();
    } else {
      items = (await SeparacaoItemRepository().select(query))
          .map(
            (item) => (
              percurso: item.codCarrinhoPercurso,
              estagio: item.itemCarrinhoPercurso,
              situacao: item.situacao,
            ),
          )
          .toList();
    }
    validate(
      stages: stages.map(
        (stage) => (
          percurso: stage.codCarrinhoPercurso,
          item: stage.item,
          situacao: stage.situacao,
        ),
      ),
      items: items,
    );
    if (conferencia) {
      final percursos = stages
          .map((stage) => stage.codCarrinhoPercurso)
          .toSet()
          .toList();
      for (var offset = 0; offset < percursos.length; offset += 200) {
        final chunk = percursos.skip(offset).take(200).toList();
        final groups = await CarrinhoPercursoAgrupamentoRepository().select(
          QueryBuilder()
              .equals('CodEmpresa', codEmpresa)
              .equals('Origem', 'CO')
              .inList('CodCarrinhoPercurso', chunk)
              .allRows(orderField: 'CodCarrinhoPercurso', thenBy: ['Item']),
        );
        validateGroups(
          stages: stages
              .where((stage) => chunk.contains(stage.codCarrinhoPercurso))
              .toList(),
          groups: groups,
        );
      }
    }
    final carts = stages.map((stage) => stage.codCarrinho).toSet().toList();
    for (var offset = 0; offset < carts.length; offset += 200) {
      final chunk = carts.skip(offset).take(200).toList();
      final history = await CarrinhoPercursoEstagioRepository().select(
        QueryBuilder()
            .equals('CodEmpresa', codEmpresa)
            .inList('CodCarrinho', chunk)
            .allRows(orderField: 'CodCarrinhoPercurso', thenBy: ['Item']),
      );
      final registrations = await CarrinhoRepository().select(
        QueryBuilder()
            .equals('CodEmpresa', codEmpresa)
            .inList('CodCarrinho', chunk)
            .allRows(orderField: 'CodCarrinho'),
      );
      validateCadastro(
        documentStages: stages.where(
          (stage) => chunk.contains(stage.codCarrinho),
        ),
        history: history,
        registrations: {
          for (final cart in registrations) cart.codCarrinho: cart.situacao,
        },
      );
    }
  }

  static void validateGroups({
    required List<ExpedicaoCarrinhoPercursoEstagioModel> stages,
    required List<ExpedicaoCarrinhoPercursoAgrupamentoModel> groups,
  }) {
    const downstream = {
      'AGRUPADO',
      'EMBALANDO',
      'EMBALADO',
      'EM ENTREGA',
      'ENTREGUE',
    };
    for (final stage in stages) {
      final active = groups
          .where(
            (group) =>
                group.codEmpresa == stage.codEmpresa &&
                group.codCarrinhoPercurso == stage.codCarrinhoPercurso &&
                group.origem == stage.origem &&
                AppHelper.sameGridItem(
                  group.itemCarrinhoPercurso,
                  stage.item,
                ) &&
                group.situacao != 'CANCELADA',
          )
          .toList();
      if ((stage.situacao == 'AGRUPADO' && active.length != 1) ||
          active.length > 1 ||
          (active.isNotEmpty && !downstream.contains(stage.situacao))) {
        throw AppError(
          'Estágio e vínculo de agrupamento divergentes no carrinho ${stage.codCarrinho}. Solicite regularização da operação parcial.',
        );
      }
      if (active.isNotEmpty) {
        final group = active.single;
        final validDestination = stages.any(
          (destination) =>
              destination.codEmpresa == stage.codEmpresa &&
              destination.codCarrinhoPercurso == stage.codCarrinhoPercurso &&
              destination.origem == stage.origem &&
              destination.codOrigem == stage.codOrigem &&
              destination.codCarrinho == group.codCarrinhoAgrupador &&
              destination.codCarrinho != stage.codCarrinho &&
              const {
                'CONFERIDO',
                'EMBALANDO',
                'EMBALADO',
                'EM ENTREGA',
                'ENTREGUE',
              }.contains(destination.situacao),
        );
        if (!validDestination) {
          throw AppError(
            'Destino do agrupamento incompatível com o estágio ${stage.item}. Solicite regularização no servidor.',
          );
        }
      }
    }
  }

  static void validateCadastro({
    required Iterable<ExpedicaoCarrinhoPercursoEstagioModel> documentStages,
    required Iterable<ExpedicaoCarrinhoPercursoEstagioModel> history,
    required Map<int, String> registrations,
  }) {
    final latest = _latestStages(history);
    for (final stage in documentStages) {
      final current = latest[stage.codCarrinho];
      final registration = registrations[stage.codCarrinho];
      if (current == null || registration == null) {
        throw AppError(
          'Cadastro ou histórico do carrinho ${stage.codCarrinho} não encontrado. Atualize novamente.',
        );
      }
      final sameStage =
          current.codCarrinhoPercurso == stage.codCarrinhoPercurso &&
          AppHelper.sameGridItem(current.item, stage.item);
      if (!sameStage) {
        if (_isOpen(stage.situacao)) {
          throw AppError(
            'O carrinho ${stage.codCarrinho} possui estágio antigo ainda aberto e já foi usado em outro estágio. Solicite regularização no servidor.',
          );
        }
        continue;
      }
      if (current.situacao != stage.situacao ||
          current.origem != stage.origem ||
          current.codOrigem != stage.codOrigem) {
        throw AppError(
          'O estágio do carrinho ${stage.codCarrinho} mudou durante a leitura. Atualize novamente.',
        );
      }
      final Set<String>? allowed;
      if (stage.origem == 'SE') {
        allowed = switch (stage.situacao) {
          'SEPARANDO' ||
          'EM SEPARACAO' ||
          'EM ANDAMENTO' => {'EM SEPARACAO', 'SEPARANDO'},
          'SEPARADO' => {'SEPARADO', 'LIBERADO'},
          'CANCELADA' || 'AGRUPADO' => {'LIBERADO'},
          _ => null,
        };
      } else if (stage.origem == 'CO') {
        allowed = switch (stage.situacao) {
          'CONFERINDO' ||
          'EM CONFERENCIA' ||
          'EM ANDAMENTO' ||
          'CANCELADA' => {'EM CONFERENCIA', 'CONFERINDO'},
          'CONFERIDO' => {'CONFERIDO'},
          'AGRUPADO' => {'LIBERADO'},
          _ => null,
        };
      } else {
        allowed = null;
      }
      if (allowed != null && !allowed.contains(registration)) {
        throw AppError(
          'O cadastro do carrinho ${stage.codCarrinho} não corresponde ao seu estágio mais recente. '
          'Novas gravações continuam bloqueadas; solicite regularização no servidor.',
          details:
              'Cadastro: $registration. Estágio ${stage.codCarrinhoPercurso}/${stage.item}: ${stage.situacao}.',
        );
      }
    }
  }

  static Map<int, ExpedicaoCarrinhoPercursoEstagioModel> _latestStages(
    Iterable<ExpedicaoCarrinhoPercursoEstagioModel> history,
  ) {
    final latest = <int, ExpedicaoCarrinhoPercursoEstagioModel>{};
    for (final stage in history) {
      final sequence = int.tryParse(AppHelper.itemSequenceKey(stage.item));
      if (sequence == null) {
        throw AppError(
          'Não foi possível ordenar o histórico do carrinho ${stage.codCarrinho}.',
        );
      }
      final previous = latest[stage.codCarrinho];
      if (previous == null ||
          stage.codCarrinhoPercurso > previous.codCarrinhoPercurso ||
          (stage.codCarrinhoPercurso == previous.codCarrinhoPercurso &&
              sequence > int.parse(AppHelper.itemSequenceKey(previous.item)))) {
        latest[stage.codCarrinho] = stage;
      }
    }
    return latest;
  }

  static bool _isOpen(String situation) => const {
    'SEPARANDO',
    'EM SEPARACAO',
    'CONFERINDO',
    'EM CONFERENCIA',
    'EM ANDAMENTO',
  }.contains(situation);

  static void validate({
    required Iterable<CarrinhoRecoveryStage> stages,
    required Iterable<CarrinhoRecoveryItem> items,
  }) {
    final byStage = <(int, String), List<String>>{};
    for (final item in items) {
      final key = (item.percurso, AppHelper.itemSequenceKey(item.estagio));
      (byStage[key] ??= []).add(item.situacao);
    }
    for (final stage in stages) {
      final states =
          byStage[(stage.percurso, AppHelper.itemSequenceKey(stage.item))] ??
          [];
      final active = states.where((state) => state != 'CA').toList();
      final opened = _isOpen(stage.situacao);
      final inconsistent =
          (stage.situacao == 'CANCELADA' && active.isNotEmpty) ||
          (opened && active.contains('FN'));
      if (inconsistent) {
        throw AppError(
          'O carrinho possui itens incompatíveis com a situação do estágio. '
          'As grades foram recarregadas, mas novas gravações continuam bloqueadas. '
          'Solicite a regularização da operação parcial no servidor.',
          details:
              'Percurso ${stage.percurso}, estágio ${stage.item}: ${stage.situacao}.',
        );
      }
    }
  }
}
