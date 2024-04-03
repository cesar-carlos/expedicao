import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoSepararConsultaModel {
  final int codEmpresa;
  final int codSepararEstoque;
  final int codTipoOperacao;
  final String nomeTipoOperacao;
  String situacao;
  final String tipoEntidade;
  final DateTime dataEmissao;
  final String horaEmissao;
  final int codEntidade;
  final String nomeEntidade;
  final int codPrioridade;
  final String nomePrioridade;
  String? historico;
  String? observacao;

  ExpedicaoSepararConsultaModel({
    required this.codEmpresa,
    required this.codSepararEstoque,
    required this.codTipoOperacao,
    required this.nomeTipoOperacao,
    required this.situacao,
    required this.tipoEntidade,
    required this.dataEmissao,
    required this.horaEmissao,
    required this.codEntidade,
    required this.nomeEntidade,
    required this.codPrioridade,
    required this.nomePrioridade,
    this.historico,
    this.observacao,
  });

  ExpedicaoSepararConsultaModel copyWith({
    int? codEmpresa,
    int? codSepararEstoque,
    int? codTipoOperacao,
    String? nomeTipoOperacao,
    String? situacao,
    String? tipoEntidade,
    DateTime? dataEmissao,
    String? horaEmissao,
    int? codEntidade,
    String? nomeEntidade,
    int? codPrioridade,
    String? nomePrioridade,
    String? historico,
    String? observacao,
  }) {
    return ExpedicaoSepararConsultaModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codSepararEstoque: codSepararEstoque ?? this.codSepararEstoque,
      codTipoOperacao: codTipoOperacao ?? this.codTipoOperacao,
      nomeTipoOperacao: nomeTipoOperacao ?? this.nomeTipoOperacao,
      situacao: situacao ?? this.situacao,
      tipoEntidade: tipoEntidade ?? this.tipoEntidade,
      dataEmissao: dataEmissao ?? this.dataEmissao,
      horaEmissao: horaEmissao ?? this.horaEmissao,
      codEntidade: codEntidade ?? this.codEntidade,
      nomeEntidade: nomeEntidade ?? this.nomeEntidade,
      codPrioridade: codPrioridade ?? this.codPrioridade,
      nomePrioridade: nomePrioridade ?? this.nomePrioridade,
      historico: historico ?? this.historico,
      observacao: observacao ?? this.observacao,
    );
  }

  factory ExpedicaoSepararConsultaModel.fromJson(Map<String, dynamic> json) {
    try {
      return ExpedicaoSepararConsultaModel(
        codEmpresa: json['CodEmpresa'],
        codSepararEstoque: json['CodSepararEstoque'],
        codTipoOperacao: json['CodTipoOperacaoExpedicao'],
        nomeTipoOperacao: json['NomeTipoOperacaoExpedicao'],
        situacao: json['Situacao'],
        tipoEntidade: json['TipoEntidade'],
        dataEmissao: AppHelper.tryStringToDate(json['DataEmissao']),
        horaEmissao: json['HoraEmissao'],
        codEntidade: json['CodEntidade'],
        nomeEntidade: json['NomeEntidade'],
        codPrioridade: json['CodPrioridade'],
        nomePrioridade: json['NomePrioridade'],
        historico: json['Historico'],
        observacao: json['Observacao'],
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodSepararEstoque': codSepararEstoque,
      'CodTipoOperacaoExpedicao': codTipoOperacao,
      'NomeTipoOperacaoExpedicao': nomeTipoOperacao,
      'Situacao': situacao,
      'TipoEntidade': tipoEntidade,
      'DataEmissao': dataEmissao.toIso8601String(),
      'HoraEmissao': horaEmissao,
      'CodEntidade': codEntidade,
      'NomeEntidade': nomeEntidade,
      'CodPrioridade': codPrioridade,
      'NomePrioridade': nomePrioridade,
      'Historico': historico,
      'Observacao': observacao,
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoSepararConsultaModel(
        codEmpresa: $codEmpresa, 
        codSepararEstoque: $codSepararEstoque, 
        codTipoOperacao: $codTipoOperacao, 
        nomeTipoOperacao: $nomeTipoOperacao, 
        situacao: $situacao, 
        tipoEntidade: $tipoEntidade, 
        dataEmissao: $dataEmissao, 
        horaEmissao: $horaEmissao, 
        codEntidade: $codEntidade, 
        nomeEntidade: $nomeEntidade, 
        codPrioridade: $codPrioridade, 
        nomePrioridade: $nomePrioridade, 
        historico: $historico, 
        observacao: $observacao
    )''';
  }
}
