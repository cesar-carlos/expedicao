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
  final DateTime? dataFinalizacao;
  final String? horaFinalizacao;
  final int codUsuario;
  final String nomeUsuario;

  ExpedicaoPercursoEstagioModel({
    required this.codEmpresa,
    required this.codCarrinhoPercurso,
    required this.item,
    required this.codPercursoEstagio,
    required this.codCarrinho,
    required this.situacao,
    required this.dataInicio,
    required this.horaInicio,
    this.dataFinalizacao,
    this.horaFinalizacao,
    required this.codUsuario,
    required this.nomeUsuario,
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
    DateTime? dataFinalizacao,
    String? horaFinalizacao,
    int? codUsuario,
    String? nomeUsuario,
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
      dataFinalizacao: dataFinalizacao ?? this.dataFinalizacao,
      horaFinalizacao: horaFinalizacao ?? this.horaFinalizacao,
      codUsuario: codUsuario ?? this.codUsuario,
      nomeUsuario: nomeUsuario ?? this.nomeUsuario,
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
      dataInicio: AppHelper.tryStringToDate(map['DataInicio']),
      horaInicio: map['HoraInicio'] ?? '00:00:00',
      dataFinalizacao: map['DataFinalizacao'],
      horaFinalizacao: map['HoraFinalizacao'],
      codUsuario: map['CodUsuario'],
      nomeUsuario: map['NomeUsuario'],
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
      'DataFinalizacao': dataFinalizacao?.toIso8601String(),
      'HoraFinalizacao': horaFinalizacao,
      'CodUsuario': codUsuario,
      'NomeUsuario': nomeUsuario,
    };
  }

  @override
  String toString() {
    return 'ExpedicaoPercursoEstagioModel(codEmpresa: $codEmpresa, codCarrinhoPercurso: $codCarrinhoPercurso, item: $item, codPercursoEstagio: $codPercursoEstagio, codCarrinho: $codCarrinho, situacao: $situacao, dataInicio: $dataInicio, horaInicio: $horaInicio, dataFinalizacao: $dataFinalizacao, horaFinalizacao: $horaFinalizacao, codUsuario: $codUsuario, nomeUsuario: $nomeUsuario)';
  }
}
