class ExpedicaoArmazenagem {
  int codEmpresa;
  int codArmazenagem;
  String? numeroDocumento;
  String situacao;
  String origem;
  int codOrigem;
  int codPrioridade;
  DateTime dataLancamento;
  String horaLancamento;
  int codUsuarioLancamento;
  String nomeUsuarioLancamento;
  String estacaoLancamento;
  String? observacao;

  ExpedicaoArmazenagem({
    required this.codEmpresa,
    required this.codArmazenagem,
    this.numeroDocumento,
    required this.situacao,
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

  ExpedicaoArmazenagem copyWith({
    int? codEmpresa,
    int? codArmazenagem,
    String? numeroDocumento,
    String? situacao,
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
    return ExpedicaoArmazenagem(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codArmazenagem: codArmazenagem ?? this.codArmazenagem,
      numeroDocumento: numeroDocumento ?? this.numeroDocumento,
      situacao: situacao ?? this.situacao,
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

  factory ExpedicaoArmazenagem.fromJson(Map<String, dynamic> json) {
    try {
      return ExpedicaoArmazenagem(
        codEmpresa: json['CodEmpresa'],
        codArmazenagem: json['CodArmazenagem'],
        numeroDocumento: json['NumeroDocumento'],
        situacao: json['Situacao'],
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
      'CodArmazenagem': codArmazenagem,
      'NumeroDocumento': numeroDocumento,
      'Situacao': situacao,
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
      ExpedicaoArmazenagem(
        codEmpresa: $codEmpresa, 
        codArmazenagem: $codArmazenagem, 
        numeroDocumento: $numeroDocumento, 
        situacao: $situacao, 
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
