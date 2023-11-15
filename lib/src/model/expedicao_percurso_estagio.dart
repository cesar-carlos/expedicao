class ExpedicaoPercursoEstagio {
  final int codPercursoEstagio;
  final String descricao;
  final String ativo;
  final String sigla;
  final int sequencia;

  ExpedicaoPercursoEstagio({
    required this.codPercursoEstagio,
    required this.descricao,
    required this.ativo,
    required this.sigla,
    required this.sequencia,
  });

  ExpedicaoPercursoEstagio copyWith({
    int? codPercursoEstagio,
    String? descricao,
    String? ativo,
    String? sigla,
    int? sequencia,
  }) {
    return ExpedicaoPercursoEstagio(
      codPercursoEstagio: codPercursoEstagio ?? this.codPercursoEstagio,
      descricao: descricao ?? this.descricao,
      ativo: ativo ?? this.ativo,
      sigla: sigla ?? this.sigla,
      sequencia: sequencia ?? this.sequencia,
    );
  }

  factory ExpedicaoPercursoEstagio.fromJson(Map<String, dynamic> map) {
    return ExpedicaoPercursoEstagio(
      codPercursoEstagio: map['CodPercursoEstagio'],
      descricao: map['Descricao'],
      ativo: map['Ativo'],
      sigla: map['Sigla'],
      sequencia: map['Sequencia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodPercursoEstagio': codPercursoEstagio,
      'Descricao': descricao,
      'Ativo': ativo,
      'Sigla': sigla,
      'Sequencia': sequencia,
    };
  }
}
