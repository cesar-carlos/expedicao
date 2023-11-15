import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoSepararCarrinhoConsultaModel {
  final int codEmpresa;
  final int codCarrinhoPercurso;
  final String origem;
  final int codOrigem;
  final int codCarrinho;
  final String carrinhoNome;
  final String codigoBarras;
  final String situacao;
  final DateTime dataInicio;
  final String horaInicio;
  final int codUsuario;
  final String nomeUsuario;

  ExpedicaoSepararCarrinhoConsultaModel({
    required this.codEmpresa,
    required this.codCarrinhoPercurso,
    required this.origem,
    required this.codOrigem,
    required this.codCarrinho,
    required this.carrinhoNome,
    required this.codigoBarras,
    required this.situacao,
    required this.dataInicio,
    required this.horaInicio,
    required this.codUsuario,
    required this.nomeUsuario,
  });

  factory ExpedicaoSepararCarrinhoConsultaModel.fromJson(
      Map<String, dynamic> map) {
    return ExpedicaoSepararCarrinhoConsultaModel(
      codEmpresa: map['CodEmpresa'],
      codCarrinhoPercurso: map['CodCarrinhoPercurso'],
      origem: map['Origem'],
      codOrigem: map['CodOrigem'],
      codCarrinho: map['CodCarrinho'],
      carrinhoNome: map['CarrinhoNome'],
      codigoBarras: map['CodigoBarras'],
      situacao: map['Situacao'],
      dataInicio: AppHelper.tryStringToDate(map['DataInicio']),
      horaInicio: map['HoraInicio'] ?? '00:00:00',
      codUsuario: map['CodUsuario'],
      nomeUsuario: map['NomeUsuario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'CodCarrinho': codCarrinho,
      'CarrinhoNome': carrinhoNome,
      'CodigoBarras': codigoBarras,
      'Situacao': situacao,
      'DataInicio': dataInicio.toIso8601String(),
      'HoraInicio': horaInicio,
      'CodUsuario': codUsuario,
      'NomeUsuario': nomeUsuario,
    };
  }
}
