class ExpedicaoEstagioModel {
  final int codPercursoEstagio;
  final String descricao;
  final String ativo;
  final String origem;
  final int sequencia;

  ExpedicaoEstagioModel({
    required this.codPercursoEstagio,
    required this.descricao,
    required this.ativo,
    required this.origem,
    required this.sequencia,
  });

  ExpedicaoEstagioModel copyWith({
    int? codPercursoEstagio,
    String? descricao,
    String? ativo,
    String? origem,
    int? sequencia,
  }) {
    return ExpedicaoEstagioModel(
      codPercursoEstagio: codPercursoEstagio ?? this.codPercursoEstagio,
      descricao: descricao ?? this.descricao,
      ativo: ativo ?? this.ativo,
      origem: origem ?? this.origem,
      sequencia: sequencia ?? this.sequencia,
    );
  }

  factory ExpedicaoEstagioModel.fromJson(Map<String, dynamic> map) {
    return ExpedicaoEstagioModel(
      codPercursoEstagio: map['CodPercursoEstagio'],
      descricao: map['Descricao'],
      ativo: map['Ativo'],
      origem: map['Origem'],
      sequencia: map['Sequencia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodPercursoEstagio': codPercursoEstagio,
      'Descricao': descricao,
      'Ativo': ativo,
      'Origem': origem,
      'Sequencia': sequencia,
    };
  }

  @override
  String toString() {
    return 'ExpedicaoEstagioModel(codPercursoEstagio: $codPercursoEstagio, descricao: $descricao, ativo: $ativo, origem: $origem, sequencia: $sequencia)';
  }
}
