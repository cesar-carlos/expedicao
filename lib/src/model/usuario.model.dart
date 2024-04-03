class UsuarioModel {
  final int codUsuario;
  final String nomeUsuario;
  final String ativo;

  UsuarioModel({
    required this.codUsuario,
    required this.nomeUsuario,
    required this.ativo,
  });

  UsuarioModel copyWith({
    int? codUsuario,
    String? nomeUsuario,
    String? ativo,
  }) {
    return UsuarioModel(
      codUsuario: codUsuario ?? this.codUsuario,
      nomeUsuario: nomeUsuario ?? this.nomeUsuario,
      ativo: ativo ?? this.ativo,
    );
  }

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      codUsuario: json['CodUsuario'] as int,
      nomeUsuario: json['NomeUsuario'] as String,
      ativo: json['Ativo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodUsuario': codUsuario,
      'NomeUsuario': nomeUsuario,
      'Ativo': ativo,
    };
  }

  @override
  String toString() {
    return '''
      UsuarioModel(
        codUsuario: $codUsuario, 
        nomeUsuario: $nomeUsuario, 
        ativo: $ativo
    )''';
  }
}
