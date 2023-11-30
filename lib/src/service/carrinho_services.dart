import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_consulta_repository.dart';
import 'package:app_expedicao/src/repository/sequencia_registro/sequencia_registro_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_consulta_model.dart';

class CarrinhoServices {
  final repository = CarrinhoRepository();
  final repositoryConsulta = CarrinhoConsultaRepository();
  final repositorySequecia = SequenciaRegistroRepository();

  Future<List<ExpedicaoCarrinhoConsultaModel>> consulta(
      [String params = '']) async {
    return await repositoryConsulta.select(params);
  }

  Future<List<ExpedicaoCarrinhoModel>> select([String params = '']) async {
    return await repository.select(params);
  }

  Future<ExpedicaoCarrinhoModel> insert(ExpedicaoCarrinhoModel carrinho) async {
    final newCarrinho = carrinho.copyWith(codCarrinho: 0);
    await repository.insert(newCarrinho);
    return newCarrinho;
  }

  Future<ExpedicaoCarrinhoModel> update(ExpedicaoCarrinhoModel carrinho) async {
    await repository.update(carrinho);
    return carrinho;
  }

  Future<void> delete(ExpedicaoCarrinhoModel carrinho) async {
    repository.delete(carrinho);
  }
}
