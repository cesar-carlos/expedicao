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
      Map<String, dynamic> json) {
    try {
      return ExpedicaoSepararCarrinhoConsultaModel(
        codEmpresa: json['CodEmpresa'],
        codCarrinhoPercurso: json['CodCarrinhoPercurso'],
        origem: json['Origem'],
        codOrigem: json['CodOrigem'],
        codCarrinho: json['CodCarrinho'],
        carrinhoNome: json['CarrinhoNome'],
        codigoBarras: json['CodigoBarras'],
        situacao: json['Situacao'],
        dataInicio: AppHelper.tryStringToDate(json['DataInicio']),
        horaInicio: json['HoraInicio'] ?? '00:00:00',
        codUsuario: json['CodUsuario'],
        nomeUsuario: json['NomeUsuario'],
      );
    } catch (e) {
      rethrow;
    }
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

  @override
  String toString() {
    return '''
      ExpedicaoSepararCarrinhoConsultaModel(
        codEmpresa: $codEmpresa, 
        codCarrinhoPercurso: $codCarrinhoPercurso, 
        origem: $origem, 
        codOrigem: $codOrigem, 
        codCarrinho: $codCarrinho, 
        carrinhoNome: $carrinhoNome, 
        codigoBarras: $codigoBarras, 
        situacao: $situacao, 
        dataInicio: $dataInicio, 
        horaInicio: $horaInicio, 
        codUsuario: $codUsuario, 
        nomeUsuario: $nomeUsuario
    )''';
  }
}
