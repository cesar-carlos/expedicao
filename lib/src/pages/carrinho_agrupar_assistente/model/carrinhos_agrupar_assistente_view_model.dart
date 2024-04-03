class CarrinhosAgruparAssistenteViewModel {
  final int codEmpresa;
  final String origem;
  final int codOrigem;

  CarrinhosAgruparAssistenteViewModel({
    required this.codEmpresa,
    required this.origem,
    required this.codOrigem,
  });

  @override
  String toString() {
    return '''
      CarrinhosAgruparAssistenteViewModel(
        codEmpresa: $codEmpresa, 
        origem: $origem, 
        codOrigem: $codOrigem
    )''';
  }
}
