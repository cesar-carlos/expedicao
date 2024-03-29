import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoConferirConsultaModel {
  final int codEmpresa;
  final int codConferir;
  final String origem;
  final int codOrigem;
  String situacao;
  final int codCarrinhoPercurso;
  final DateTime dataLancamento;
  final String horaLancamento;
  final String tipoEntidade;
  final int codEntidade;
  final String nomeEntidade;
  final int codPrioridade;
  final String nomePrioridade;
  final String? historico;
  final String? observacao;

  ExpedicaoConferirConsultaModel({
    required this.codEmpresa,
    required this.codConferir,
    required this.origem,
    required this.codOrigem,
    required this.situacao,
    required this.codCarrinhoPercurso,
    required this.dataLancamento,
    required this.horaLancamento,
    required this.tipoEntidade,
    required this.codEntidade,
    required this.nomeEntidade,
    required this.codPrioridade,
    required this.nomePrioridade,
    this.historico,
    this.observacao,
  });

  ExpedicaoConferirConsultaModel copyWith({
    int? codEmpresa,
    int? codConferir,
    String? origem,
    int? codOrigem,
    String? situacao,
    int? codCarrinhoPercurso,
    DateTime? dataLancamento,
    String? horaLancamento,
    String? tipoEntidade,
    int? codEntidade,
    String? nomeEntidade,
    int? codPrioridade,
    String? nomePrioridade,
    String? historico,
    String? observacao,
  }) {
    return ExpedicaoConferirConsultaModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codConferir: codConferir ?? this.codConferir,
      origem: origem ?? this.origem,
      codOrigem: codOrigem ?? this.codOrigem,
      situacao: situacao ?? this.situacao,
      codCarrinhoPercurso: codCarrinhoPercurso ?? this.codCarrinhoPercurso,
      dataLancamento: dataLancamento ?? this.dataLancamento,
      horaLancamento: horaLancamento ?? this.horaLancamento,
      tipoEntidade: tipoEntidade ?? this.tipoEntidade,
      codEntidade: codEntidade ?? this.codEntidade,
      nomeEntidade: nomeEntidade ?? this.nomeEntidade,
      codPrioridade: codPrioridade ?? this.codPrioridade,
      nomePrioridade: nomePrioridade ?? this.nomePrioridade,
      historico: historico ?? this.historico,
      observacao: observacao ?? this.observacao,
    );
  }

  factory ExpedicaoConferirConsultaModel.fromJson(Map map) {
    try {
      return ExpedicaoConferirConsultaModel(
        codEmpresa: map['CodEmpresa'],
        codConferir: map['CodConferir'],
        origem: map['Origem'],
        codOrigem: map['CodOrigem'],
        situacao: map['Situacao'],
        codCarrinhoPercurso: map['CodCarrinhoPercurso'],
        dataLancamento: AppHelper.tryStringToDate(map['DataLancamento']),
        horaLancamento: map['HoraLancamento'],
        tipoEntidade: map['TipoEntidade'],
        codEntidade: map['CodEntidade'],
        nomeEntidade: map['NomeEntidade'],
        codPrioridade: map['CodPrioridade'],
        nomePrioridade: map['NomePrioridade'],
        historico: map['Historico'],
        observacao: map['Observacao'],
      );
    } catch (e) {
      print('Erro ao converter json para ExpedicaoConferirConsultaModel: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodConferir': codConferir,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'Situacao': situacao,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'DataLancamento': dataLancamento.toIso8601String(),
      'HoraLancamento': horaLancamento,
      'TipoEntidade': tipoEntidade,
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
      ExpedicaoConferirConsultaModel(
        codEmpresa: $codEmpresa, 
        codConferir: $codConferir, 
        origem: $origem, 
        codOrigem: $codOrigem, 
        situacao: $situacao, 
        codCarrinhoPercurso: $codCarrinhoPercurso, 
        dataLancamento: $dataLancamento, 
        horaLancamento: $horaLancamento, 
        tipoEntidade: $tipoEntidade, 
        codEntidade: $codEntidade, 
        nomeEntidade: $nomeEntidade, 
        codPrioridade: $codPrioridade, 
        nomePrioridade: $nomePrioridade, 
        historico: $historico, 
        observacao: $observacao
      )''';
  }
}
