import 'package:app_expedicao/src/model/expedicao_separar_model.dart';
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

  SepararFinalizarService({
    required this.separarConsulta,
    required this.carrinhoPercurso,
  });

  Future<void> execute() async {
    try {
      final separarRepository = SepararRepository();
      final carrinhoPercursoRepository = CarrinhoPercursoRepository();

      final tipoOperacao = await _getTipoOperacao(
        this.separarConsulta.codEmpresa,
        this.separarConsulta.codTipoOperacao,
      );

      final separar = await _getSeparar(
        this.separarConsulta.codEmpresa,
        this.separarConsulta.codSepararEstoque,
      );

      final newSeparar = separar.copyWith(
        situacao: ExpedicaoSituacaoModel.separado,
      );

      final newCarrinhoPercurso = this
          .carrinhoPercurso
          .copyWith(situacao: ExpedicaoSituacaoModel.separado);

      await separarRepository.update(newSeparar);
      await carrinhoPercursoRepository.update(newCarrinhoPercurso);

      if (tipoOperacao.fazerConferencia == 'S') {
        await _addConferir(newCarrinhoPercurso);
      }

      if (tipoOperacao.fazerConferencia == 'N' &&
          tipoOperacao.fazerArmazenamento == 'S') {
        _addArmazenar(newCarrinhoPercurso);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ExpedicaoSepararModel> _getSeparar(
      int codEmpresa, int codSepararEstoque) async {
    try {
      final models = await SepararRepository().select('''
            CodEmpresa = $codEmpresa
          AND CodSepararEstoque = $codSepararEstoque ''');

      if (models.isEmpty) throw AppError('Separar não encontrado');
      return models.first;
    } catch (e) {
      rethrow;
    }
  }

  Future<ExpedicaoTipoOperacaoModel> _getTipoOperacao(
      int codEmpresa, int codTipoOperacaoExpedicao) async {
    try {
      final repository = TipoOperacaoRepository();
      final models = await repository.select('''
            CodEmpresa = $codEmpresa
          AND CodTipoOperacaoExpedicao = $codTipoOperacaoExpedicao ''');

      if (models.isEmpty) throw AppError('Tipo de operação não encontrado');

      return models.first;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _addConferir(ExpedicaoCarrinhoPercursoModel model) async {
    try {
      await ConferirSeparacaoAdicionarService(model).execute();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _addArmazenar(ExpedicaoCarrinhoPercursoModel model) async {
    try {
      await ArmazenarSeparacaoAdicionarService(model).execute();
    } catch (e) {
      rethrow;
    }
  }
}
