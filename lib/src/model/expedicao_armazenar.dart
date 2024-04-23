class ExpedicaoArmazenar {
  int codEmpresa;
  int codArmazenar;
  String? numeroDocumento;
  String origem;
  int codOrigem;
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
    this.numeroDocumento,
    required this.origem,
    required this.codOrigem,
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
    String? numeroDocumento,
    String? origem,
    int? codOrigem,
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
      numeroDocumento: numeroDocumento ?? this.numeroDocumento,
      origem: origem ?? this.origem,
      codOrigem: codOrigem ?? this.codOrigem,
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
        numeroDocumento: json['NumeroDocumento'],
        origem: json['Origem'],
        codOrigem: json['CodOrigem'],
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
      'NumeroDocumento': numeroDocumento,
      'Origem': origem,
      'CodOrigem': codOrigem,
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
        numeroDocumento: $numeroDocumento,
        origem: $origem, 
        codOrigem: $codOrigem, 
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
