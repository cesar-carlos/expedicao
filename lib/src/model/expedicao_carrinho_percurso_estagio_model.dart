import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoCarrinhoPercursoEstagioModel {
  final int codEmpresa;
  final int codCarrinhoPercurso;
  final String item;
  final String origem;
  final int codOrigem;
  final int codPercursoEstagio;
  final int codCarrinho;
  final String situacao;
  final DateTime dataInicio;
  final String horaInicio;
  final int codUsuarioInicio;
  final String nomeUsuarioInicio;
  final DateTime? dataFinalizacao;
  final String? horaFinalizacao;
  final int? codUsuarioFinalizacao;
  final String? nomeUsuarioFinalizacao;

  ExpedicaoCarrinhoPercursoEstagioModel({
    required this.codEmpresa,
    required this.codCarrinhoPercurso,
    required this.item,
    required this.origem,
    required this.codOrigem,
    required this.codPercursoEstagio,
    required this.codCarrinho,
    required this.situacao,
    required this.dataInicio,
    required this.horaInicio,
    required this.codUsuarioInicio,
    required this.nomeUsuarioInicio,
    this.dataFinalizacao,
    this.horaFinalizacao,
    this.codUsuarioFinalizacao,
    this.nomeUsuarioFinalizacao,
  });

  ExpedicaoCarrinhoPercursoEstagioModel copyWith({
    int? codEmpresa,
    int? codCarrinhoPercurso,
    String? item,
    String? origem,
    int? codOrigem,
    int? codPercursoEstagio,
    int? codCarrinho,
    String? situacao,
    DateTime? dataInicio,
    String? horaInicio,
    int? codUsuarioInicio,
    String? nomeUsuarioInicio,
    DateTime? dataFinalizacao,
    String? horaFinalizacao,
    int? codUsuarioFinalizacao,
    String? nomeUsuarioFinalizacao,
  }) {
    return ExpedicaoCarrinhoPercursoEstagioModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codCarrinhoPercurso: codCarrinhoPercurso ?? this.codCarrinhoPercurso,
      item: item ?? this.item,
      origem: origem ?? this.origem,
      codOrigem: codOrigem ?? this.codOrigem,
      codPercursoEstagio: codPercursoEstagio ?? this.codPercursoEstagio,
      codCarrinho: codCarrinho ?? this.codCarrinho,
      situacao: situacao ?? this.situacao,
      dataInicio: dataInicio ?? this.dataInicio,
      horaInicio: horaInicio ?? this.horaInicio,
      codUsuarioInicio: codUsuarioInicio ?? this.codUsuarioInicio,
      nomeUsuarioInicio: nomeUsuarioInicio ?? this.nomeUsuarioInicio,
      dataFinalizacao: dataFinalizacao ?? this.dataFinalizacao,
      horaFinalizacao: horaFinalizacao ?? this.horaFinalizacao,
      codUsuarioFinalizacao:
          codUsuarioFinalizacao ?? this.codUsuarioFinalizacao,
      nomeUsuarioFinalizacao:
          nomeUsuarioFinalizacao ?? this.nomeUsuarioFinalizacao,
    );
  }

  factory ExpedicaoCarrinhoPercursoEstagioModel.fromJson(
      Map<String, dynamic> json) {
    try {
      return ExpedicaoCarrinhoPercursoEstagioModel(
        codEmpresa: json['CodEmpresa'],
        codCarrinhoPercurso: json['CodCarrinhoPercurso'],
        item: json['Item'],
        origem: json['Origem'],
        codOrigem: json['CodOrigem'],
        codPercursoEstagio: json['CodPercursoEstagio'],
        codCarrinho: json['CodCarrinho'],
        situacao: json['Situacao'],
        dataInicio: DateTime.parse(json['DataInicio']),
        horaInicio: json['HoraInicio'],
        codUsuarioInicio: json['CodUsuarioInicio'],
        nomeUsuarioInicio: json['NomeUsuarioInicio'],
        dataFinalizacao:
            AppHelper.tryStringToDateOrNull(json['DataFinalizacao']),
        horaFinalizacao: json['HoraFinalizacao'],
        codUsuarioFinalizacao: json['CodUsuarioFinalizacao'],
        nomeUsuarioFinalizacao: json['NomeUsuarioFinalizacao'],
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'Item': item,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'CodPercursoEstagio': codPercursoEstagio,
      'CodCarrinho': codCarrinho,
      'Situacao': situacao,
      'DataInicio': dataInicio.toIso8601String(),
      'HoraInicio': horaInicio,
      'CodUsuarioInicio': codUsuarioInicio,
      'NomeUsuarioInicio': nomeUsuarioInicio,
      'DataFinalizacao': dataFinalizacao?.toIso8601String(),
      'HoraFinalizacao': horaFinalizacao,
      'CodUsuarioFinalizacao': codUsuarioFinalizacao,
      'NomeUsuarioFinalizacao': nomeUsuarioFinalizacao,
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoPercursoEstagioModel(
        codEmpresa: $codEmpresa, 
        odCarrinhoPercurso: $codCarrinhoPercurso, 
        item: $item, 
        origem: $origem, 
        codOrigem: $codOrigem, 
        codPercursoEstagio: $codPercursoEstagio, 
        codCarrinho: $codCarrinho, 
        situacao: $situacao, 
        dataInicio: $dataInicio, 
        horaInicio: $horaInicio, 
        codUsuarioInicio: $codUsuarioInicio, 
        nomeUsuarioInicio: $nomeUsuarioInicio, 
        dataFinalizacao: $dataFinalizacao, 
        horaFinalizacao: $horaFinalizacao, 
        codUsuarioFinalizacao: $codUsuarioFinalizacao, 
        nomeUsuarioFinalizacao: $nomeUsuarioFinalizacao
    )''';
  }
}
