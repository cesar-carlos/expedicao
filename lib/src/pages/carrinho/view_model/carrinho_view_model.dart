class CarrinhoViewModel {
  late int codCarrinho;
  late String descricaoCarrinho;
  late String situacao;
  late String local;
  late String setor;
  late String observacao;
  late String codigoBarras;

  CarrinhoViewModel({
    required this.codCarrinho,
    required this.descricaoCarrinho,
    required this.situacao,
    required this.local,
    required this.setor,
    required this.observacao,
    required this.codigoBarras,
  });

  CarrinhoViewModel.empty() {
    codCarrinho = 0;
    descricaoCarrinho = '';
    situacao = '';
    local = '';
    setor = '';
    observacao = '';
    codigoBarras = '';
  }

  CarrinhoViewModel copyWith({
    int? codCarrinho,
    String? descricaoCarrinho,
    String? situacao,
    String? local,
    String? setor,
    String? observacao,
    String? codigoBarras,
  }) {
    return CarrinhoViewModel(
      codCarrinho: codCarrinho ?? this.codCarrinho,
      descricaoCarrinho: descricaoCarrinho ?? this.descricaoCarrinho,
      situacao: situacao ?? this.situacao,
      local: local ?? this.local,
      setor: setor ?? this.setor,
      observacao: observacao ?? this.observacao,
      codigoBarras: codigoBarras ?? this.codigoBarras,
    );
  }

  void clear() {
    codCarrinho = 0;
    descricaoCarrinho = '';
    situacao = '';
    local = '';
    setor = '';
    observacao = '';
    codigoBarras = '';
  }
}
