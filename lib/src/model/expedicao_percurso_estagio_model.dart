import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoPercursoEstagioModel {
  final int codEmpresa;
  final int codCarrinhoPercurso;
  final String item;
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

  ExpedicaoPercursoEstagioModel({
    required this.codEmpresa,
    required this.codCarrinhoPercurso,
    required this.item,
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

  ExpedicaoPercursoEstagioModel copyWith({
    int? codEmpresa,
    int? codCarrinhoPercurso,
    String? item,
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
    return ExpedicaoPercursoEstagioModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codCarrinhoPercurso: codCarrinhoPercurso ?? this.codCarrinhoPercurso,
      item: item ?? this.item,
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

  factory ExpedicaoPercursoEstagioModel.fromJson(Map<String, dynamic> map) {
    return ExpedicaoPercursoEstagioModel(
      codEmpresa: map['CodEmpresa'],
      codCarrinhoPercurso: map['CodCarrinhoPercurso'],
      item: map['Item'],
      codPercursoEstagio: map['CodPercursoEstagio'],
      codCarrinho: map['CodCarrinho'],
      situacao: map['Situacao'],
      dataInicio: DateTime.parse(map['DataInicio']),
      horaInicio: map['HoraInicio'],
      codUsuarioInicio: map['CodUsuarioInicio'],
      nomeUsuarioInicio: map['NomeUsuarioInicio'],
      dataFinalizacao: AppHelper.tryStringToDateOrNull(map['DataFinalizacao']),
      horaFinalizacao: map['HoraFinalizacao'],
      codUsuarioFinalizacao: map['CodUsuarioFinalizacao'],
      nomeUsuarioFinalizacao: map['NomeUsuarioFinalizacao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'Item': item,
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
    return 'ExpedicaoPercursoEstagioModel(codEmpresa: $codEmpresa, codCarrinhoPercurso: $codCarrinhoPercurso, item: $item, codPercursoEstagio: $codPercursoEstagio, codCarrinho: $codCarrinho, situacao: $situacao, dataInicio: $dataInicio, horaInicio: $horaInicio, codUsuarioInicio: $codUsuarioInicio, nomeUsuarioInicio: $nomeUsuarioInicio, dataFinalizacao: $dataFinalizacao, horaFinalizacao: $horaFinalizacao, codUsuarioFinalizacao: $codUsuarioFinalizacao, nomeUsuarioFinalizacao: $nomeUsuarioFinalizacao)';
  }
}
