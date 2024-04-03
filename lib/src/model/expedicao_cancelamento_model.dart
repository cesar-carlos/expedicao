class ExpedicaoCancelamentoModel {
  final int codEmpresa;
  final int codCancelamento;
  final String origem;
  final int codOrigem;
  final String itemOrigem;
  int? codMotivoCancelamento;
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
    this.codMotivoCancelamento,
    required this.dataCancelamento,
    required this.horaCancelamento,
    required this.codUsuarioCancelamento,
    required this.nomeUsuarioCancelamento,
    this.observacaoCancelamento,
  });

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

  factory ExpedicaoCancelamentoModel.fromJson(Map<String, dynamic> json) {
    try {
      return ExpedicaoCancelamentoModel(
        codEmpresa: json['CodEmpresa'],
        codCancelamento: json['CodCancelamento'],
        origem: json['Origem'],
        codOrigem: json['CodOrigem'],
        itemOrigem: json['ItemOrigem'],
        codMotivoCancelamento: json['CodMotivoCancelamento'],
        dataCancelamento: DateTime.parse(json['DataCancelamento']),
        horaCancelamento: json['HoraCancelamento'],
        codUsuarioCancelamento: json['CodUsuarioCancelamento'],
        nomeUsuarioCancelamento: json['NomeUsuarioCancelamento'],
        observacaoCancelamento: json['ObservacaoCancelamento'],
      );
    } catch (_) {
      rethrow;
    }
  }

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

  @override
  String toString() {
    return '''
      ExpedicaoCancelamentoModel(
        codEmpresa: $codEmpresa, 
        codCancelamento: $codCancelamento, 
        origem: $origem, 
        codOrigem: $codOrigem, 
        itemOrigem: $itemOrigem, 
        codMotivoCancelamento: $codMotivoCancelamento, 
        dataCancelamento: $dataCancelamento, 
        horaCancelamento: $horaCancelamento, 
        codUsuarioCancelamento: $codUsuarioCancelamento, 
        nomeUsuarioCancelamento: $nomeUsuarioCancelamento, 
        observacaoCancelamento: $observacaoCancelamento
    )''';
  }
}
