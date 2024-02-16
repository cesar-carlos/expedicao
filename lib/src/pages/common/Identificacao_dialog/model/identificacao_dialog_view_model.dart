class IdentificacaoDialogViewModel {
  final int codUsuario;
  final String nomeUsuario;

  IdentificacaoDialogViewModel({
    required this.codUsuario,
    required this.nomeUsuario,
  });

  @override
  String toString() {
    return '''
      IdentificacaoModel(
        codUsuario: $codUsuario, 
        nomeUsuario: $nomeUsuario)
      ''';
  }
}
