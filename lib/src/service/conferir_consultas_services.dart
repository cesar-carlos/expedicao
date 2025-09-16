import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_conferir_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_unidade_medida_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_carrinho_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferencia_item/conferencia_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_unidade_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_consulta_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class ConferirConsultaServices {
  final int codEmpresa;
  final int codConferir;

  final conferirConsultaRepository = ConferirConsultaRepository();

  final conferirCarrinhoConsultaRepository =
      ConferirCarrinhoConsultaRepository();

  final conferirItemConsultaRepository = ConferirItemConsultaRepository();

  final conferirItemUnidadeMedidaConsultaRepository =
      ConferirItemUnidadeMedidaConsultaRepository();

  final conferenciaItemConsultaRepository = ConferenciaItemConsultaRepository();
  final carrinhoPercursoEstagioConsultaRepository =
      CarrinhoPercursoEstagioConsultaRepository();

  ConferirConsultaServices({
    required this.codEmpresa,
    required this.codConferir,
  });

  Future<ExpedicaoConferirConsultaModel?> conferir() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodConferir', codConferir);

      final response = await conferirConsultaRepository.select(queryBuilder);

      if (response.isEmpty) {
        return null;
      }

      return response.first;
    } catch (e) {
      throw Exception('Erro ao buscar conferência: $e');
    }
  }

  Future<List<ExpedicaoCarrinhoConferirConsultaModel>>
      carrinhosConferir() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodConferir', codConferir);

      final response =
          await conferirCarrinhoConsultaRepository.select(queryBuilder);
      return response;
    } catch (e) {
      throw Exception('Erro ao buscar carrinhos de conferência: $e');
    }
  }

  Future<ExpedicaoCarrinhoConferirConsultaModel> carrinhoConferir(
      int codCarrinho) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodConferir', codConferir)
          .equals('CodCarrinho', codCarrinho);

      final response =
          await conferirCarrinhoConsultaRepository.select(queryBuilder);

      if (response.isEmpty) {
        throw Exception('Carrinho não encontrado');
      }

      return response.first;
    } catch (e) {
      if (e is Exception && e.toString().contains('não encontrado')) {
        rethrow;
      }
      throw Exception('Erro ao buscar carrinho de conferência: $e');
    }
  }

  Future<List<ExpedicaoConferirItemConsultaModel>> itensConferir() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodConferir', codConferir);

      return await conferirItemConsultaRepository.select(queryBuilder);
    } catch (e) {
      throw Exception('Erro ao buscar itens de conferência: $e');
    }
  }

  Future<List<ExpedicaoConferirItemUnidadeMedidaConsultaModel>>
      itensConferirUnidades() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodConferir', codConferir);

      return await conferirItemUnidadeMedidaConsultaRepository
          .select(queryBuilder);
    } catch (e) {
      throw Exception('Erro ao buscar itens de conferência com unidades: $e');
    }
  }

  Future<List<ExpedicaConferenciaItemConsultaModel>> itensConferencia() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodConferir', codConferir);

      final result =
          await conferenciaItemConsultaRepository.select(queryBuilder);
      return result;
    } catch (e) {
      throw Exception('Erro ao buscar itens de conferência: $e');
    }
  }

  Future<List<ExpedicaoCarrinhoPercursoEstagioConsultaModel>>
      carrinhosPercurso() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('Origem', ExpedicaoOrigemModel.conferencia)
          .equals('CodOrigem', codConferir);

      final result =
          await carrinhoPercursoEstagioConsultaRepository.select(queryBuilder);
      return result;
    } catch (e) {
      throw Exception('Erro ao buscar carrinhos de percurso: $e');
    }
  }

  Future<List<ExpedicaConferenciaItemConsultaModel>> itensCarrinho(
      int codCarrinho) async {
    try {
      final itensConferenciaList = await itensConferencia();

      return itensConferenciaList.where((el) {
        return el.codCarrinho == codCarrinho;
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar itens do carrinho: $e');
    }
  }

  Future<bool> isComplete() async {
    try {
      final itensConferirList = await itensConferir();
      return itensConferirList
          .every((el) => el.quantidade == el.quantidadeConferida);
    } catch (e) {
      throw Exception('Erro ao verificar completude da conferência: $e');
    }
  }

  Future<bool> existsOpenCart() async {
    try {
      final carrinhosPercursoList = await carrinhosPercurso();

      final carrinhosConferindo = carrinhosPercursoList.where((el) {
        return el.situacao == ExpedicaoSituacaoModel.conferindo;
      });

      return carrinhosConferindo.isNotEmpty;
    } catch (e) {
      throw Exception('Erro ao verificar carrinhos abertos: $e');
    }
  }
}
