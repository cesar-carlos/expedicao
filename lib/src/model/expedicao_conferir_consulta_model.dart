import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoConferirConsultaModel {
  final int codEmpresa;
  final int codConferir;
  final String origem;
  final int codOrigem;
  final int codPrioridade;
  final String nomePrioridade;
  String situacao;
  final DateTime data;
  final String hora;
  String? historico;
  String? observacao;

  ExpedicaoConferirConsultaModel({
    required this.codEmpresa,
    required this.codConferir,
    required this.origem,
    required this.codOrigem,
    required this.codPrioridade,
    required this.nomePrioridade,
    required this.situacao,
    required this.data,
    required this.hora,
    this.historico,
    this.observacao,
  });

  ExpedicaoConferirConsultaModel copyWith({
    int? codEmpresa,
    int? codConferir,
    String? origem,
    int? codOrigem,
    int? codPrioridade,
    String? nomePrioridade,
    String? situacao,
    DateTime? data,
    String? hora,
    String? historico,
    String? observacao,
  }) {
    return ExpedicaoConferirConsultaModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codConferir: codConferir ?? this.codConferir,
      origem: origem ?? this.origem,
      codOrigem: codOrigem ?? this.codOrigem,
      codPrioridade: codPrioridade ?? this.codPrioridade,
      nomePrioridade: nomePrioridade ?? this.nomePrioridade,
      situacao: situacao ?? this.situacao,
      data: data ?? this.data,
      hora: hora ?? this.hora,
      historico: historico ?? this.historico,
      observacao: observacao ?? this.observacao,
    );
  }

  factory ExpedicaoConferirConsultaModel.fromJson(Map map) {
    return ExpedicaoConferirConsultaModel(
      codEmpresa: map['CodEmpresa'],
      codConferir: map['CodConferir'],
      origem: map['Origem'],
      codOrigem: map['CodOrigem'],
      codPrioridade: map['CodPrioridade'],
      nomePrioridade: map['NomePrioridade'],
      situacao: map['Situacao'],
      data: AppHelper.tryStringToDate(map['Data']),
      hora: map['Hora'] ?? '00:00:00',
      historico: map['Historico'],
      observacao: map['Observacao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "CodEmpresa": codEmpresa,
      "CodConferir": codConferir,
      "Origem": origem,
      "CodOrigem": codOrigem,
      "CodPrioridade": codPrioridade,
      "NomePrioridade": nomePrioridade,
      "Situacao": situacao,
      "Data": data.toIso8601String(),
      "Hora": hora,
      "Historico": historico,
      "Observacao": observacao,
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
        codPrioridade: $codPrioridade, 
        nomePrioridade: $nomePrioridade, 
        situacao: $situacao, 
        data: $data, 
        hora: $hora, 
        historico: $historico, 
        observacao: $observacao)
      ''';
  }
}
