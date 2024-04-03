import 'package:app_expedicao/src/app/app_helper.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';

class ExpedicaoCarrinhoPercursoModel {
  final int codEmpresa;
  final int codCarrinhoPercurso;
  final String origem;
  final int codOrigem;
  final String situacao;
  final DateTime dataInicio;
  final String horaInicio;
  final DateTime? dataFinalizacao;
  final String? horaFinalizacao;

  ExpedicaoCarrinhoPercursoModel({
    required this.codEmpresa,
    required this.codCarrinhoPercurso,
    required this.origem,
    required this.codOrigem,
    required this.situacao,
    required this.dataInicio,
    required this.horaInicio,
    this.dataFinalizacao,
    this.horaFinalizacao,
  });

  ExpedicaoCarrinhoPercursoModel copyWith({
    int? codEmpresa,
    int? codCarrinhoPercurso,
    String? origem,
    int? codOrigem,
    int? codCarrinho,
    String? situacao,
    DateTime? dataInicio,
    String? horaInicio,
    DateTime? dataFinalizacao,
    String? horaFinalizacao,
  }) {
    return ExpedicaoCarrinhoPercursoModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codCarrinhoPercurso: codCarrinhoPercurso ?? this.codCarrinhoPercurso,
      origem: origem ?? this.origem,
      codOrigem: codOrigem ?? this.codOrigem,
      situacao: situacao ?? this.situacao,
      dataInicio: dataInicio ?? this.dataInicio,
      horaInicio: horaInicio ?? this.horaInicio,
      dataFinalizacao: dataFinalizacao ?? this.dataFinalizacao,
      horaFinalizacao: horaFinalizacao ?? this.horaFinalizacao,
    );
  }

  factory ExpedicaoCarrinhoPercursoModel.fromConsulta(
      ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    return ExpedicaoCarrinhoPercursoModel(
      codEmpresa: item.codEmpresa,
      codCarrinhoPercurso: item.codCarrinhoPercurso,
      origem: item.origem,
      codOrigem: item.codOrigem,
      situacao: item.situacao,
      dataInicio: item.dataInicio,
      horaInicio: item.horaInicio,
      dataFinalizacao: item.dataFinalizacao,
      horaFinalizacao: item.horaFinalizacao,
    );
  }

  factory ExpedicaoCarrinhoPercursoModel.fromJson(Map<String, dynamic> json) {
    try {
      return ExpedicaoCarrinhoPercursoModel(
        codEmpresa: json['CodEmpresa'],
        codCarrinhoPercurso: json['CodCarrinhoPercurso'],
        origem: json['Origem'],
        codOrigem: json['CodOrigem'],
        situacao: json['Situacao'],
        dataInicio: AppHelper.tryStringToDate(json['DataInicio']),
        horaInicio: json['HoraInicio'] ?? '00:00:00',
        dataFinalizacao:
            AppHelper.tryStringToDateOrNull(json['DataFinalizacao']),
        horaFinalizacao: json['HoraFinalizacao'],
      );
    } catch (_) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'Situacao': situacao,
      'DataInicio': dataInicio.toIso8601String(),
      'HoraInicio': horaInicio,
      'DataFinalizacao': dataFinalizacao?.toIso8601String(),
      'HoraFinalizacao': horaFinalizacao,
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoCarrinhoPercursoModel(
        codEmpresa: $codEmpresa, 
        codCarrinhoPercurso: $codCarrinhoPercurso, 
        rigem: $origem, 
        codOrigem: $codOrigem, 
        situacao: $situacao, 
        dataInicio: $dataInicio, 
        horaInicio: $horaInicio, 
        dataFinalizacao: $dataFinalizacao, 
        horaFinalizacao: $horaFinalizacao
    )''';
  }
}
