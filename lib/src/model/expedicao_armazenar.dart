class ExpedicaoArmazenar {
  int codEmpresa;
  int codArmazenar;
  String origem;
  int codOrigem;
  String? numeroDocumento;
  int codPrioridade;
  DateTime dataLancamento;
  String horaLancamento;
  int codUsuarioLancamento;
  String nomeUsuarioLancamento;
  String estacaoLancamento;
  String? observacao;

  ExpedicaoArmazenar({
    required this.codEmpresa,
    required this.codArmazenar,
    required this.origem,
    required this.codOrigem,
    this.numeroDocumento,
    required this.codPrioridade,
    required this.dataLancamento,
    required this.horaLancamento,
    required this.codUsuarioLancamento,
    required this.nomeUsuarioLancamento,
    required this.estacaoLancamento,
    this.observacao,
  });

  ExpedicaoArmazenar copyWith({
    int? codEmpresa,
    int? codArmazenar,
    String? origem,
    int? codOrigem,
    String? numeroDocumento,
    int? codPrioridade,
    DateTime? dataLancamento,
    String? horaLancamento,
    int? codUsuarioLancamento,
    String? nomeUsuarioLancamento,
    String? estacaoLancamento,
    String? observacao,
  }) {
    return ExpedicaoArmazenar(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codArmazenar: codArmazenar ?? this.codArmazenar,
      origem: origem ?? this.origem,
      codOrigem: codOrigem ?? this.codOrigem,
      numeroDocumento: numeroDocumento ?? this.numeroDocumento,
      codPrioridade: codPrioridade ?? this.codPrioridade,
      dataLancamento: dataLancamento ?? this.dataLancamento,
      horaLancamento: horaLancamento ?? this.horaLancamento,
      codUsuarioLancamento: codUsuarioLancamento ?? this.codUsuarioLancamento,
      nomeUsuarioLancamento:
          nomeUsuarioLancamento ?? this.nomeUsuarioLancamento,
      estacaoLancamento: estacaoLancamento ?? this.estacaoLancamento,
      observacao: observacao ?? this.observacao,
    );
  }

  factory ExpedicaoArmazenar.fromJson(Map<String, dynamic> json) {
    try {
      return ExpedicaoArmazenar(
        codEmpresa: json['CodEmpresa'],
        codArmazenar: json['CodArmazenar'],
        origem: json['Origem'],
        codOrigem: json['CodOrigem'],
        numeroDocumento: json['NumeroDocumento'],
        codPrioridade: json['CodPrioridade'],
        dataLancamento: DateTime.parse(json['DataLancamento']),
        horaLancamento: json['HoraLancamento'],
        codUsuarioLancamento: json['CodUsuarioLancamento'],
        nomeUsuarioLancamento: json['NomeUsuarioLancamento'],
        estacaoLancamento: json['EstacaoLancamento'],
        observacao: json['Observacao'],
      );
    } catch (_) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodArmazenar': codArmazenar,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'NumeroDocumento': numeroDocumento,
      'CodPrioridade': codPrioridade,
      'DataLancamento': dataLancamento.toIso8601String(),
      'HoraLancamento': horaLancamento,
      'CodUsuarioLancamento': codUsuarioLancamento,
      'NomeUsuarioLancamento': nomeUsuarioLancamento,
      'EstacaoLancamento': estacaoLancamento,
      'Observacao': observacao,
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoArmazenar(
        codEmpresa: $codEmpresa, 
        codArmazenar: $codArmazenar, 
        origem: $origem, 
        codOrigem: $codOrigem, 
        numeroDocumento: $numeroDocumento,
        codPrioridade: $codPrioridade, 
        dataLancamento: $dataLancamento, 
        horaLancamento: $horaLancamento, 
        codUsuarioLancamento: $codUsuarioLancamento, 
        nomeUsuarioLancamento: $nomeUsuarioLancamento, 
        estacaoLancamento: $estacaoLancamento, 
        observacao: $observacao
    )''';
  }
}
