class ExpedicaoTipoOperacaoModel {
  int codEmpresa;
  int codTipoOperacaoExpedicao;
  String descricao;
  String ativo;
  String tipo;
  int? codSetorConferencia;
  int? codPrioridade;
  int? codRelatorio;
  int codLocalArmazenagem;
  String movimentaEstoque;
  int codTipoMovimentoEstoque;
  String fazerConferencia;
  String fazerArmazenamento;
  String controlaLote;
  String controlaNumeroSerie;

  ExpedicaoTipoOperacaoModel({
    required this.codEmpresa,
    required this.codTipoOperacaoExpedicao,
    required this.descricao,
    required this.ativo,
    required this.tipo,
    this.codSetorConferencia,
    this.codPrioridade,
    this.codRelatorio,
    required this.codLocalArmazenagem,
    required this.movimentaEstoque,
    required this.codTipoMovimentoEstoque,
    required this.fazerConferencia,
    required this.fazerArmazenamento,
    required this.controlaLote,
    required this.controlaNumeroSerie,
  });

  ExpedicaoTipoOperacaoModel copyWith({
    int? codEmpresa,
    int? codTipoOperacaoExpedicao,
    String? descricao,
    String? ativo,
    String? tipo,
    int? codSetorConferencia,
    int? codPrioridade,
    int? codRelatorio,
    int? codLocalArmazenagem,
    String? movimentaEstoque,
    int? codTipoMovimentoEstoque,
    String? fazerConferencia,
    String? fazerArmazenamento,
    String? controlaLote,
    String? controlaNumeroSerie,
  }) {
    return ExpedicaoTipoOperacaoModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codTipoOperacaoExpedicao:
          codTipoOperacaoExpedicao ?? this.codTipoOperacaoExpedicao,
      descricao: descricao ?? this.descricao,
      ativo: ativo ?? this.ativo,
      tipo: tipo ?? this.tipo,
      codSetorConferencia: codSetorConferencia ?? this.codSetorConferencia,
      codPrioridade: codPrioridade ?? this.codPrioridade,
      codRelatorio: codRelatorio ?? this.codRelatorio,
      codLocalArmazenagem: codLocalArmazenagem ?? this.codLocalArmazenagem,
      movimentaEstoque: movimentaEstoque ?? this.movimentaEstoque,
      codTipoMovimentoEstoque:
          codTipoMovimentoEstoque ?? this.codTipoMovimentoEstoque,
      fazerConferencia: fazerConferencia ?? this.fazerConferencia,
      fazerArmazenamento: fazerArmazenamento ?? this.fazerArmazenamento,
      controlaLote: controlaLote ?? this.controlaLote,
      controlaNumeroSerie: controlaNumeroSerie ?? this.controlaNumeroSerie,
    );
  }

  factory ExpedicaoTipoOperacaoModel.fromJson(Map<String, dynamic> json) {
    try {
      return ExpedicaoTipoOperacaoModel(
        codEmpresa: json['CodEmpresa'],
        codTipoOperacaoExpedicao: json['CodTipoOperacaoExpedicao'],
        descricao: json['Descricao'],
        ativo: json['Ativo'],
        tipo: json['Tipo'],
        codSetorConferencia: json['CodSetorConferencia'],
        codPrioridade: json['CodPrioridade'],
        codRelatorio: json['CodRelatorio'],
        codLocalArmazenagem: json['CodLocalArmazenagem'],
        movimentaEstoque: json['MovimentaEstoque'],
        codTipoMovimentoEstoque: json['CodTipoMovimentoEstoque'],
        fazerConferencia: json['FazerConferencia'],
        fazerArmazenamento: json['FazerArmazenamento'],
        controlaLote: json['ControlaLote'],
        controlaNumeroSerie: json['ControlaNumeroSerie'],
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodTipoOperacaoExpedicao': codTipoOperacaoExpedicao,
      'Descricao': descricao,
      'Ativo': ativo,
      'Tipo': tipo,
      'CodSetorConferencia': codSetorConferencia,
      'CodPrioridade': codPrioridade,
      'CodRelatorio': codRelatorio,
      'CodLocalArmazenagem': codLocalArmazenagem,
      'MovimentaEstoque': movimentaEstoque,
      'CodTipoMovimentoEstoque': codTipoMovimentoEstoque,
      'FazerConferencia': fazerConferencia,
      'FazerArmazenamento': fazerArmazenamento,
      'ControlaLote': controlaLote,
      'ControlaNumeroSerie': controlaNumeroSerie,
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoTipoOperacaoModel(
        codEmpresa: $codEmpresa, 
        codTipoOperacaoExpedicao: $codTipoOperacaoExpedicao, 
        descricao: $descricao, 
        ativo: $ativo, 
        tipo: $tipo, 
        codSetorConferencia: $codSetorConferencia, 
        codPrioridade: $codPrioridade, 
        codRelatorio: $codRelatorio, 
        codLocalArmazenagem: $codLocalArmazenagem, 
        movimentaEstoque: $movimentaEstoque, 
        codTipoMovimentoEstoque: $codTipoMovimentoEstoque, 
        fazerConferencia: $fazerConferencia, 
        fazerArmazenamento: $fazerArmazenamento, 
        controlaLote: $controlaLote, 
        controlaNumeroSerie: $controlaNumeroSerie
    )''';
  }
}
