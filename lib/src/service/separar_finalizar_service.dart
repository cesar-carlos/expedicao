import 'package:app_expedicao/src/model/expedicao_separar_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/model/expedicao_tipo_operacao_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separar/separar_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_tipo_operacao/tipo_operacao_repository.dart';
import 'package:app_expedicao/src/service/armazenar_separacao_adicionar_service.dart';
import 'package:app_expedicao/src/service/conferir_separacao_adicionar_service.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class SepararFinalizarService {
  final ExpedicaoSepararConsultaModel separarConsulta;
  final ExpedicaoCarrinhoPercursoModel carrinhoPercurso;
  final carrinhoPercursoRepository = CarrinhoPercursoRepository();
  final tipoOperacaoRepository = TipoOperacaoRepository();
  final separarRepository = SepararRepository();

  SepararFinalizarService({
    required this.separarConsulta,
    required this.carrinhoPercurso,
  });

  Future<void> execute() async {
    try {
      //TODO: REVER CONFIGURAÇÃO
      //final tipoOperacao = await _getTipoOperacao(
      //  separarConsulta.codEmpresa,
      //  separarConsulta.codTipoOperacao,
      //);

      final separar = await _getSeparar(
        separarConsulta.codEmpresa,
        separarConsulta.codSepararEstoque,
      );

      final newSeparar = separar.copyWith(
        situacao: ExpedicaoSituacaoModel.separado,
      );

      final newCarrinhoPercurso = carrinhoPercurso.copyWith(
        situacao: ExpedicaoSituacaoModel.separado,
      );

      await separarRepository.update(newSeparar);
      await carrinhoPercursoRepository.update(newCarrinhoPercurso);

      //if (tipoOperacao.fazerConferencia == 'S') {
      //  await _addConferir(newCarrinhoPercurso);
      //}

      // if (tipoOperacao.fazerConferencia == 'N' &&
      //     tipoOperacao.fazerArmazenamento == 'S') {
      //   await _addArmazenar(newCarrinhoPercurso);
      // }
    } catch (e) {
      throw Exception('Erro ao finalizar separação: $e');
    }
  }

  Future<ExpedicaoSepararModel> _getSeparar(
      int codEmpresa, int codSepararEstoque) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodSepararEstoque', codSepararEstoque);

      final models = await separarRepository.select(queryBuilder);

      if (models.isEmpty) {
        throw AppError('Separar não encontrado');
      }

      return models.first;
    } catch (e) {
      if (e is AppError) rethrow;
      throw Exception('Erro ao buscar separação: $e');
    }
  }

  Future<ExpedicaoTipoOperacaoModel> _getTipoOperacao(
      int codEmpresa, int codTipoOperacaoExpedicao) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodTipoOperacaoExpedicao', codTipoOperacaoExpedicao);

      final models = await tipoOperacaoRepository.select(queryBuilder);

      if (models.isEmpty) {
        throw AppError('Tipo de operação não encontrado');
      }

      return models.first;
    } catch (e) {
      if (e is AppError) rethrow;
      throw Exception('Erro ao buscar tipo de operação: $e');
    }
  }

  Future<void> _addConferir(ExpedicaoCarrinhoPercursoModel model) async {
    try {
      await ConferirSeparacaoAdicionarService(model).execute();
    } catch (e) {
      throw Exception('Erro ao criar conferência: $e');
    }
  }

  Future<void> _addArmazenar(ExpedicaoCarrinhoPercursoModel model) async {
    try {
      await ArmazenarSeparacaoAdicionarService(model).execute();
    } catch (e) {
      throw Exception('Erro ao criar armazenamento: $e');
    }
  }
}
