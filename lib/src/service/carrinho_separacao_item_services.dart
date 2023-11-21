import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';

class CarrinhoSeparacaoItemServices {
  final SeparacaoItemConsultaRepository consultaRepository;
  final SeparacaoItemRepository repository;

  CarrinhoSeparacaoItemServices()
      : consultaRepository = SeparacaoItemConsultaRepository(),
        repository = SeparacaoItemRepository();

  Future<List<ExpedicaSeparacaoItemConsultaModel>> consulta(String params) {
    return consultaRepository.select(params);
  }

  Future<void> insert(ExpedicaoSeparacaoItemModel entity) {
    return repository.insert(entity);
  }
}
