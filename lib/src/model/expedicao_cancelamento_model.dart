import 'package:app_expedicao/src/model/basic_model.dart';

class ExpedicaoCancelamentoModel implements BasicModel {
  final int codEmpresa;
  final int codCancelamento;
  final String origem;
  final int codOrigem;
  final String itemOrigem;
  final int codMotivoCancelamento;
  final DateTime dataCancelamento;
  final String horaCancelamento;
  final int codUsuarioCancelamento;
  final String nomeUsuarioCancelamento;
  final String? observacaoCancelamento;

  ExpedicaoCancelamentoModel({
    required this.codEmpresa,
    required this.codCancelamento,
    required this.origem,
    required this.codOrigem,
    required this.itemOrigem,
    required this.codMotivoCancelamento,
    required this.dataCancelamento,
    required this.horaCancelamento,
    required this.codUsuarioCancelamento,
    required this.nomeUsuarioCancelamento,
    this.observacaoCancelamento,
  });

  @override
  ExpedicaoCancelamentoModel copyWith({
    int? codEmpresa,
    int? codCancelamento,
    String? origem,
    int? codOrigem,
    String? itemOrigem,
    int? codMotivoCancelamento,
    DateTime? dataCancelamento,
    String? horaCancelamento,
    int? codUsuarioCancelamento,
    String? nomeUsuarioCancelamento,
    String? observacaoCancelamento,
  }) {
    return ExpedicaoCancelamentoModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codCancelamento: codCancelamento ?? this.codCancelamento,
      origem: origem ?? this.origem,
      codOrigem: codOrigem ?? this.codOrigem,
      itemOrigem: itemOrigem ?? this.itemOrigem,
      codMotivoCancelamento:
          codMotivoCancelamento ?? this.codMotivoCancelamento,
      dataCancelamento: dataCancelamento ?? this.dataCancelamento,
      horaCancelamento: horaCancelamento ?? this.horaCancelamento,
      codUsuarioCancelamento:
          codUsuarioCancelamento ?? this.codUsuarioCancelamento,
      nomeUsuarioCancelamento:
          nomeUsuarioCancelamento ?? this.nomeUsuarioCancelamento,
      observacaoCancelamento:
          observacaoCancelamento ?? this.observacaoCancelamento,
    );
  }

  factory ExpedicaoCancelamentoModel.fromJson(Map<String, dynamic> map) {
    return ExpedicaoCancelamentoModel(
      codEmpresa: map['CodEmpresa'],
      codCancelamento: map['CodCancelamento'],
      origem: map['Origem'],
      codOrigem: map['CodOrigem'],
      itemOrigem: map['ItemOrigem'],
      codMotivoCancelamento: map['CodMotivoCancelamento'],
      dataCancelamento: DateTime.parse(map['DataCancelamento']),
      horaCancelamento: map['HoraCancelamento'],
      codUsuarioCancelamento: map['CodUsuarioCancelamento'],
      nomeUsuarioCancelamento: map['NomeUsuarioCancelamento'],
      observacaoCancelamento: map['ObservacaoCancelamento'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodCancelamento': codCancelamento,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'ItemOrigem': itemOrigem,
      'CodMotivoCancelamento': codMotivoCancelamento,
      'DataCancelamento': dataCancelamento.toIso8601String(),
      'HoraCancelamento': horaCancelamento,
      'CodUsuarioCancelamento': codUsuarioCancelamento,
      'NomeUsuarioCancelamento': nomeUsuarioCancelamento,
      'ObservacaoCancelamento': observacaoCancelamento,
    };
  }
}
