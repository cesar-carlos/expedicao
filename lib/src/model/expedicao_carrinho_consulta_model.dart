import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoCarrinhoConsultaModel {
  final int codEmpresa;
  final int codCarrinho;
  final String descricaoCarrinho;
  final String ativo;
  final String situacao;
  final String codigoBarras;
  final int? codCarrinhoPercurso;
  final int? codPercursoEstagio;
  final String? descricaoPercursoEstagio;
  final String? origem;
  final int? codOrigem;
  final DateTime? dataInicio;
  final String? horaInicio;
  final int? codUsuarioInicio;
  final String? nomeUsuarioInicio;
  final int? codSetorEstoque;
  final String? nomeSetorEstoque;

  ExpedicaoCarrinhoConsultaModel({
    required this.codEmpresa,
    required this.codCarrinho,
    required this.descricaoCarrinho,
    required this.ativo,
    required this.situacao,
    required this.codigoBarras,
    this.codCarrinhoPercurso,
    this.codPercursoEstagio,
    this.descricaoPercursoEstagio,
    this.origem = '',
    this.codOrigem,
    this.dataInicio,
    this.horaInicio,
    this.codUsuarioInicio,
    this.nomeUsuarioInicio,
    this.codSetorEstoque,
    this.nomeSetorEstoque,
  });

  factory ExpedicaoCarrinhoConsultaModel.fromJson(Map<String, dynamic> json) {
    try {
      return ExpedicaoCarrinhoConsultaModel(
        codEmpresa: json['CodEmpresa'],
        codCarrinho: json['CodCarrinho'],
        descricaoCarrinho: json['Descricao'],
        ativo: json['Ativo'],
        situacao: json['Situacao'] ?? '',
        codigoBarras: json['CodigoBarras'],
        codCarrinhoPercurso: json['CodCarrinhoPercurso'],
        codPercursoEstagio: json['CodPercursoEstagio'],
        descricaoPercursoEstagio: json['DescricaoPercursoEstagio'],
        origem: json['Origem'] ?? '',
        codOrigem: json['CodOrigem'],
        dataInicio: AppHelper.tryStringToDateOrNull(json['DataInicio']),
        horaInicio: json['HoraInicio'],
        codUsuarioInicio: json['CodUsuarioInicio'],
        nomeUsuarioInicio: json['NomeUsuarioInicio'],
        codSetorEstoque: json['CodSetorEstoque'],
        nomeSetorEstoque: json['NomeSetorEstoque'],
      );
    } catch (_) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodCarrinho': codCarrinho,
      'Descricao': descricaoCarrinho,
      'Ativo': ativo,
      'Situacao': situacao,
      'CodigoBarras': codigoBarras,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'CodPercursoEstagio': codPercursoEstagio,
      'DescricaoPercursoEstagio': descricaoPercursoEstagio,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'DataInicio': dataInicio?.toIso8601String(),
      'HoraInicio': horaInicio,
      'CodUsuarioInicio': codUsuarioInicio,
      'NomeUsuarioInicio': nomeUsuarioInicio,
      'CodSetorEstoque': codSetorEstoque,
      'NomeSetorEstoque': nomeSetorEstoque,
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoCarrinhoConsultaModel(
        codEmpresa: $codEmpresa, 
        codCarrinho: $codCarrinho, 
        descricaoCarrinho: $descricaoCarrinho, 
        ativo: $ativo, 
        situacao: $situacao, 
        codigoBarras: $codigoBarras, 
        codCarrinhoPercurso: $codCarrinhoPercurso, 
        codPercursoEstagio: $codPercursoEstagio, 
        descricaoPercursoEstagio: $descricaoPercursoEstagio, 
        origem: $origem, 
        codOrigem: $codOrigem, 
        dataInicio: $dataInicio, 
        horaInicio: $horaInicio, 
        codUsuarioInicio: $codUsuarioInicio, 
        nomeUsuarioInicio: $nomeUsuarioInicio, 
        codSetorEstoque: $codSetorEstoque, 
        nomeSetorEstoque: $nomeSetorEstoque
    )''';
  }
}
