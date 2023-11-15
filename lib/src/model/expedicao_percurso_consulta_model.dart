import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoPercursoConsultaModel {
  final int codEmpresa;
  final int codCarrinhoPercurso;
  final int codPercursoEstagio;
  final String origem;
  final int codOrigem;
  final String situacao;
  final int codCarrinho;
  final String nomeCarrinho;
  final String codigoBarrasCarrinho;
  final String ativo;
  final DateTime? dataInicio;
  final String? horaInicio;
  final DateTime? dataFinalizacao;
  final String? horaFinalizacao;
  final int? codUsuario;
  final String? nomeUsuario;
  final int? codSetorEstoque;
  final String? nomeSetorEstoque;

  ExpedicaoPercursoConsultaModel({
    required this.codEmpresa,
    required this.codCarrinhoPercurso,
    required this.codPercursoEstagio,
    required this.origem,
    required this.codOrigem,
    required this.situacao,
    required this.codCarrinho,
    required this.nomeCarrinho,
    required this.codigoBarrasCarrinho,
    required this.ativo,
    this.dataInicio,
    this.horaInicio,
    this.dataFinalizacao,
    this.horaFinalizacao,
    this.codUsuario,
    this.nomeUsuario,
    this.codSetorEstoque,
    this.nomeSetorEstoque,
  });

  factory ExpedicaoPercursoConsultaModel.fromJson(Map<String, dynamic> map) {
    return ExpedicaoPercursoConsultaModel(
      codEmpresa: map['CodEmpresa'],
      codCarrinhoPercurso: map['CodCarrinhoPercurso'],
      codPercursoEstagio: map['CodPercursoEstagio'],
      origem: map['Origem'],
      codOrigem: map['CodOrigem'],
      situacao: map['Situacao'],
      codCarrinho: map['CodCarrinho'],
      nomeCarrinho: map['NomeCarrinho'],
      codigoBarrasCarrinho: map['CodigoBarrasCarrinho'],
      ativo: map['Ativo'],
      dataInicio: AppHelper.tryStringToDate(map['DataInicio']),
      horaInicio: map['HoraInicio'] ?? '00:00:00',
      dataFinalizacao: AppHelper.tryStringToDate(map['DataFinalizacao']),
      horaFinalizacao: map['HoraFinalizacao'],
      codUsuario: map['CodUsuario'],
      nomeUsuario: map['NomeUsuario'],
      codSetorEstoque: map['CodSetorEstoque'],
      nomeSetorEstoque: map['NomeSetorEstoque'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'CodPercursoEstagio': codPercursoEstagio,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'Situacao': situacao,
      'CodCarrinho': codCarrinho,
      'NomeCarrinho': nomeCarrinho,
      'CodigoBarrasCarrinho': codigoBarrasCarrinho,
      'Ativo': ativo,
      'DataInicio': dataInicio,
      'HoraInicio': horaInicio,
      'DataFinalizacao': dataFinalizacao,
      'HoraFinalizacao': horaFinalizacao,
      'CodUsuario': codUsuario,
      'NomeUsuario': nomeUsuario,
      'CodSetorEstoque': codSetorEstoque,
      'NomeSetorEstoque': nomeSetorEstoque,
    };
  }
}
