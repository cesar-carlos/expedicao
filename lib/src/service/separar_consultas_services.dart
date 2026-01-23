import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_unidade_medida_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separar_item/separar_item_unidade_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separar_item/separar_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separar/separar_consulta_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class SepararConsultaServices {
  final int codEmpresa;
  final int codSepararEstoque;

  final separarConsultaRepository = SepararConsultaRepository();
  final separarItemConsultaRepository = SepararItemConsultaRepository();
  final separarItemUnidadeMedidaConsultaRepository =
      SepararItemUnidadeMedidaConsultaRepository();
  final separacaoItemConsultaRepository = SeparacaoItemConsultaRepository();
  final carrinhoPercursoEstagioConsultaRepository =
      CarrinhoPercursoEstagioConsultaRepository();

  SepararConsultaServices({
    required this.codEmpresa,
    required this.codSepararEstoque,
  });

  Future<ExpedicaoSepararConsultaModel?> separar() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodSepararEstoque', codSepararEstoque);

      final response = await separarConsultaRepository.select(queryBuilder);
      if (response.isEmpty) {
        return null;
      }

      return response.last;
    } catch (e) {
      throw Exception('Erro ao buscar separação: $e');
    }
  }

  Future<List<ExpedicaoSepararItemConsultaModel>> itensSaparar() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodSepararEstoque', codSepararEstoque);

      return await separarItemConsultaRepository.select(queryBuilder);
    } catch (e) {
      throw Exception('Erro ao buscar itens para separar: $e');
    }
  }

  Future<List<ExpedicaoSepararItemUnidadeMedidaConsultaModel>>
      itensSapararUnidades() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodSepararEstoque', codSepararEstoque);

      return await separarItemUnidadeMedidaConsultaRepository
          .select(queryBuilder);
    } catch (e) {
      throw Exception('Erro ao buscar unidades de medida dos itens: $e');
    }
  }

  Future<List<ExpedicaSeparacaoItemConsultaModel>> itensSeparacao() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodSepararEstoque', codSepararEstoque);

      return await separacaoItemConsultaRepository.select(queryBuilder);
    } catch (e) {
      throw Exception('Erro ao buscar itens de separação: $e');
    }
  }

  Future<List<ExpedicaSeparacaoItemConsultaModel>> itensCarrinho(
      int codCarrinho) async {
    try {
      final itensSeparacaoList = await itensSeparacao();

      return itensSeparacaoList
          .where((el) => el.codCarrinho == codCarrinho)
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar itens do carrinho: $e');
    }
  }

  Future<List<ExpedicaoCarrinhoPercursoEstagioConsultaModel>>
      carrinhosPercurso() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('Origem', ExpedicaoOrigemModel.separacao)
          .equals('CodOrigem', codSepararEstoque);

      return await carrinhoPercursoEstagioConsultaRepository
          .select(queryBuilder);
    } catch (e) {
      throw Exception('Erro ao buscar carrinhos do percurso: $e');
    }
  }

  Future<bool> isComplete() async {
    try {
      final itensSapararList = await itensSaparar();
      return itensSapararList
          .every((el) => el.quantidade == el.quantidadeSeparacao);
    } catch (e) {
      throw Exception('Erro ao verificar se separação está completa: $e');
    }
  }

  Future<bool> cartIsValid(int codCarrinho) async {
    try {
      // Busca apenas os itens separados do carrinho específico
      final itensSeparacaoCarrinho = await itensCarrinho(codCarrinho);
      
      // Filtra apenas itens não cancelados do carrinho
      final itensSeparadosCarrinho = itensSeparacaoCarrinho
          .where((el) => el.situacao != ExpedicaoItemSituacaoModel.cancelado)
          .toList();

      // Se o carrinho não tem itens, não precisa validar
      if (itensSeparadosCarrinho.isEmpty) {
        return true;
      }

      // Busca os itens a separar (gerais da separação)
      final itensSapararList = await itensSaparar();

      // Agrupa itens separados do carrinho por produto e soma quantidades
      final itensSeparadosCarrinhoGroup = itensSeparadosCarrinho
          .map((el) => (codProduto: el.codProduto, total: 0.00))
          .toSet();

      final itensSeparadoCarrinhoGroupTotais =
          itensSeparadosCarrinhoGroup.map((element) {
        final soma = itensSeparadosCarrinho
            .where((el) => el.codProduto == element.codProduto)
            .fold(0.00, (prev, el) => prev + el.quantidade);

        return (codProduto: element.codProduto, total: soma);
      }).toList();

      // Agrupa itens a separar por produto e soma quantidades
      final itensSapararGroup = itensSapararList
          .map((el) => (codProduto: el.codProduto, total: 0.00))
          .toSet();

      final itensSapararGroupTotais = itensSapararGroup.map((element) {
        final soma = itensSapararList
            .where((el) => el.codProduto == element.codProduto)
            .fold(0.00, (prev, el) => prev + el.quantidade);

        return (codProduto: element.codProduto, total: soma);
      }).toList();

      // Valida cada produto do carrinho
      for (var itemCarrinho in itensSeparadoCarrinhoGroupTotais) {
        // Busca a quantidade total a separar para este produto
        final quantidadeASeparar = itensSapararGroupTotais
            .firstWhere(
                (element) => element.codProduto == itemCarrinho.codProduto,
                orElse: () => (codProduto: itemCarrinho.codProduto, total: 0.00))
            .total;

        // Se a quantidade separada no carrinho exceder a quantidade total a separar, está inválido
        if (itemCarrinho.total > quantidadeASeparar) {
          return false;
        }
      }

      return true;
    } catch (e) {
      throw Exception('Erro ao validar carrinho: $e');
    }
  }

  Future<bool> existsOpenCart() async {
    try {
      final carrinhosPercursoList = await carrinhosPercurso();

      final carrinhosEmAndamento = carrinhosPercursoList
          .where((el) => el.situacao == ExpedicaoSituacaoModel.separando);

      return carrinhosEmAndamento.isNotEmpty;
    } catch (e) {
      throw Exception('Erro ao verificar se existe carrinho aberto: $e');
    }
  }
}
