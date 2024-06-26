class ExpedicaoTipoOperacaoArmazenagem {
  int codEmpresa;
  int codTipoOperacaoArmazenagem;
  String descricao;
  String ativo;
  int codPrioridade;
  int codRelatorio;
  int codLocalArmazenagem;
  int? codSetorArmazenagem;
  String movimentaEstoque;
  int codTipoMovimentoEstoque;
  int controlaLote;
  int controlaSerie;

  ExpedicaoTipoOperacaoArmazenagem({
    required this.codEmpresa,
    required this.codTipoOperacaoArmazenagem,
    required this.descricao,
    required this.ativo,
    required this.codPrioridade,
    required this.codRelatorio,
    required this.codLocalArmazenagem,
    this.codSetorArmazenagem,
    required this.movimentaEstoque,
    required this.codTipoMovimentoEstoque,
    required this.controlaLote,
    required this.controlaSerie,
  });

  ExpedicaoTipoOperacaoArmazenagem copyWith({
    int? codEmpresa,
    int? codTipoOperacaoArmazenagem,
    String? descricao,
    String? ativo,
    int? codPrioridade,
    int? codRelatorio,
    int? codLocalArmazenagem,
    int? codSetorArmazenagem,
    String? movimentaEstoque,
    int? codTipoMovimentoEstoque,
    int? controlaLote,
    int? controlaSerie,
  }) {
    return ExpedicaoTipoOperacaoArmazenagem(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codTipoOperacaoArmazenagem:
          codTipoOperacaoArmazenagem ?? this.codTipoOperacaoArmazenagem,
      descricao: descricao ?? this.descricao,
      ativo: ativo ?? this.ativo,
      codPrioridade: codPrioridade ?? this.codPrioridade,
      codRelatorio: codRelatorio ?? this.codRelatorio,
      codLocalArmazenagem: codLocalArmazenagem ?? this.codLocalArmazenagem,
      codSetorArmazenagem: codSetorArmazenagem ?? this.codSetorArmazenagem,
      movimentaEstoque: movimentaEstoque ?? this.movimentaEstoque,
      codTipoMovimentoEstoque:
          codTipoMovimentoEstoque ?? this.codTipoMovimentoEstoque,
      controlaLote: controlaLote ?? this.controlaLote,
      controlaSerie: controlaSerie ?? this.controlaSerie,
    );
  }

  factory ExpedicaoTipoOperacaoArmazenagem.fromJson(Map<String, dynamic> json) {
    try {
      return ExpedicaoTipoOperacaoArmazenagem(
        codEmpresa: json['CodEmpresa'],
        codTipoOperacaoArmazenagem: json['CodTipoOperacaoArmazenagem'],
        descricao: json['Descricao'],
        ativo: json['Ativo'],
        codPrioridade: json['CodPrioridade'],
        codRelatorio: json['CodRelatorio'],
        codLocalArmazenagem: json['CodLocalArmazenagem'],
        codSetorArmazenagem: json['CodSetorArmazenagem'],
        movimentaEstoque: json['movimentaEstoque'],
        codTipoMovimentoEstoque: json['codTipoMovimentoEstoque'],
        controlaLote: json['controlaLote'],
        controlaSerie: json['controlaSerie'],
      );
    } catch (_) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodTipoOperacaoArmazenagem': codTipoOperacaoArmazenagem,
      'Descricao': descricao,
      'Ativo': ativo,
      'CodPrioridade': codPrioridade,
      'CodRelatorio': codRelatorio,
      'CodLocalArmazenagem': codLocalArmazenagem,
      'CodSetorArmazenagem': codSetorArmazenagem,
      'MovimentaEstoque': movimentaEstoque,
      'CodTipoMovimentoEstoque': codTipoMovimentoEstoque,
      'ControlaLote': controlaLote,
      'ControlaSerie': controlaSerie,
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoTipoOperacaoArmazenagem(
        codEmpresa: $codEmpresa, 
        codTipoOperacaoArmazenagem: $codTipoOperacaoArmazenagem, 
        descricao: $descricao, 
        ativo: $ativo, 
        codPrioridade: $codPrioridade, 
        codRelatorio: $codRelatorio, 
        codLocalArmazenagem: $codLocalArmazenagem, 
        codSetorArmazenagem: $codSetorArmazenagem, 
        movimentaEstoque: $movimentaEstoque, 
        codTipoMovimentoEstoque: $codTipoMovimentoEstoque, 
        controlaLote: $controlaLote, 
        controlaSerie: $controlaSerie
    )''';
  }
}
