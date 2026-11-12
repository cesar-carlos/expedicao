import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_conferir_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_unidade_medida_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_carrinho_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferencia_item/conferencia_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_unidade_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_consulta_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class ConferirConsultaServices {
  final int codEmpresa;
  final int codConferir;

  final conferirConsultaRepository = ConferirConsultaRepository();

  final conferirCarrinhoConsultaRepository =
      ConferirCarrinhoConsultaRepository();

  final conferirItemConsultaRepository = ConferirItemConsultaRepository();
  final conferirItemRepository = ConferirItemRepository();

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
      throw AppError.fromUnknown(e);
    }
  }

  Future<List<ExpedicaoCarrinhoConferirConsultaModel>>
  carrinhosConferir() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodConferir', codConferir)
          .allRows(orderField: 'ItemCarrinhoPercurso');

      final response = await conferirCarrinhoConsultaRepository.select(
        queryBuilder,
      );
      return response;
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<ExpedicaoCarrinhoConferirConsultaModel> carrinhoConferir(
    int codCarrinho,
  ) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodConferir', codConferir)
          .equals('CodCarrinho', codCarrinho);

      final response = await conferirCarrinhoConsultaRepository.select(
        queryBuilder,
      );

      if (response.isEmpty) {
        throw AppError('Carrinho não encontrado');
      }

      return response.first;
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<List<ExpedicaoConferirItemConsultaModel>> itensConferir({
    required int codCarrinho,
  }) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodConferir', codConferir)
          .equals('CodCarrinho', codCarrinho);

      return await conferirItemConsultaRepository.select(
        queryBuilder.allRows(),
      );
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<List<ExpedicaoConferirItemUnidadeMedidaConsultaModel>>
  itensConferirUnidades() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodConferir', codConferir)
          .allRows(thenBy: ['ItemUnidadeMedida']);

      return await conferirItemUnidadeMedidaConsultaRepository.select(
        queryBuilder,
      );
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<List<ExpedicaConferenciaItemConsultaModel>> itensConferencia({
    required int codCarrinho,
  }) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodConferir', codConferir)
          .equals('CodCarrinho', codCarrinho);

      final result = await conferenciaItemConsultaRepository.select(
        queryBuilder.allRows(),
      );
      return result;
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<List<ExpedicaoCarrinhoPercursoEstagioConsultaModel>>
  carrinhosPercurso({int? codCarrinhoPercurso, String? item}) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('Origem', ExpedicaoOrigemModel.conferencia)
          .equals('CodOrigem', codConferir);

      if (codCarrinhoPercurso != null) {
        queryBuilder.equals('CodCarrinhoPercurso', codCarrinhoPercurso);
      }

      if (item != null && item.isNotEmpty) {
        queryBuilder.equals('Item', item);
      }

      final result = await carrinhoPercursoEstagioConsultaRepository.select(
        queryBuilder.allRows(),
      );
      return result;
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<List<ExpedicaConferenciaItemConsultaModel>> itensCarrinho(
    int codCarrinho,
  ) async {
    try {
      return await itensConferencia(codCarrinho: codCarrinho);
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<bool> isComplete() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodConferir', codConferir)
          .allRows();

      final itensConferirList = await conferirItemRepository.select(
        queryBuilder,
      );
      if (itensConferirList.isEmpty) return false;
      return itensConferirList.every(
        (el) => el.quantidade == el.quantidadeConferida,
      );
    } catch (e) {
      throw AppError.fromUnknown(e);
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
      throw AppError.fromUnknown(e);
    }
  }
}
