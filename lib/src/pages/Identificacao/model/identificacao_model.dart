class IdentificacaoModel {
  final int codUsuario;
  final String nomeUsuario;

  IdentificacaoModel({
    required this.codUsuario,
    required this.nomeUsuario,
  });

  @override
  String toString() {
    return 'IdentificacaoModel(codUsuario: $codUsuario, nomeUsuario: $nomeUsuario)';
  }
}
