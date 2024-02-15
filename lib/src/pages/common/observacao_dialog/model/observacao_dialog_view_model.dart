class ObservacaoDialogViewModel {
  final String title;
  final String? historico;
  final String? observacao;

  ObservacaoDialogViewModel({
    required this.title,
    this.historico,
    this.observacao,
  });

  @override
  String toString() {
    return '''
      ObservacaoDialogViewModel(
        title: $title, 
        historico: $historico, 
        observacao: $observacao)
      ''';
  }
}
