class UsuarioConsultaMoldel {
  final int codEmpresa;
  final int codUsuario;
  final String nomeUsuario;
  final String ativo;
  final String? codContaFinanceira;
  final String? nomeContaFinanceira;
  final String? nomeCaixaOperador;
  final int? codLocalArmazenagem;
  final String? nomeLocalArmazenagem;
  final int? codVendedor;
  final String? nomeVendedor;
  final int? codSetorEstoque;
  final String? descricaoSetorEstoque;
  final String permiteSepararForaSequencia;
  final String visualizaTodasSeparacoes;
  final int? codSetorConferencia;
  final String? descricaoSetorConferencia;
  final String permiteConferirForaSequencia;
  final String visualizaTodasConferencias;
  final String salvaCarrinhoOutroUsuario;
  final String editaCarrinhoOutroUsuario;
  final String excluiCarrinhoOutroUsuario;

  UsuarioConsultaMoldel({
    required this.codEmpresa,
    required this.codUsuario,
    required this.nomeUsuario,
    required this.ativo,
    this.codContaFinanceira,
    this.nomeContaFinanceira,
    this.nomeCaixaOperador,
    this.codLocalArmazenagem,
    this.nomeLocalArmazenagem,
    this.codVendedor,
    this.nomeVendedor,
    this.codSetorEstoque,
    this.descricaoSetorEstoque,
    required this.permiteSepararForaSequencia,
    required this.visualizaTodasSeparacoes,
    this.codSetorConferencia,
    this.descricaoSetorConferencia,
    required this.permiteConferirForaSequencia,
    required this.visualizaTodasConferencias,
    required this.salvaCarrinhoOutroUsuario,
    required this.editaCarrinhoOutroUsuario,
    required this.excluiCarrinhoOutroUsuario,
  });

  UsuarioConsultaMoldel copyWith({
    int? codEmpresa,
    int? codUsuario,
    String? nomeUsuario,
    String? ativo,
    String? codContaFinanceira,
    String? nomeContaFinanceira,
    String? nomeCaixaOperador,
    int? codLocalArmazenagem,
    String? nomeLocalArmazenagem,
    int? codVendedor,
    String? nomeVendedor,
    int? codSetorEstoque,
    String? descricaoSetorEstoque,
    String? permiteSepararForaSequencia,
    String? visualizaTodasSeparacoes,
    int? codSetorConferencia,
    String? descricaoSetorConferencia,
    String? permiteConferirForaSequencia,
    String? visualizaTodasConferencias,
    String? salvaCarrinhoOutroUsuario,
    String? editaCarrinhoOutroUsuario,
    String? excluiCarrinhoOutroUsuario,
  }) {
    return UsuarioConsultaMoldel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codUsuario: codUsuario ?? this.codUsuario,
      nomeUsuario: nomeUsuario ?? this.nomeUsuario,
      ativo: ativo ?? this.ativo,
      codContaFinanceira: codContaFinanceira ?? this.codContaFinanceira,
      nomeContaFinanceira: nomeContaFinanceira ?? this.nomeContaFinanceira,
      nomeCaixaOperador: nomeCaixaOperador ?? this.nomeCaixaOperador,
      codLocalArmazenagem: codLocalArmazenagem ?? this.codLocalArmazenagem,
      nomeLocalArmazenagem: nomeLocalArmazenagem ?? this.nomeLocalArmazenagem,
      codVendedor: codVendedor ?? this.codVendedor,
      nomeVendedor: nomeVendedor ?? this.nomeVendedor,
      codSetorEstoque: codSetorEstoque ?? this.codSetorEstoque,
      descricaoSetorEstoque:
          descricaoSetorEstoque ?? this.descricaoSetorEstoque,
      permiteSepararForaSequencia:
          permiteSepararForaSequencia ?? this.permiteSepararForaSequencia,
      visualizaTodasSeparacoes:
          visualizaTodasSeparacoes ?? this.visualizaTodasSeparacoes,
      codSetorConferencia: codSetorConferencia ?? this.codSetorConferencia,
      descricaoSetorConferencia:
          descricaoSetorConferencia ?? this.descricaoSetorConferencia,
      permiteConferirForaSequencia:
          permiteConferirForaSequencia ?? this.permiteConferirForaSequencia,
      visualizaTodasConferencias:
          visualizaTodasConferencias ?? this.visualizaTodasConferencias,
      salvaCarrinhoOutroUsuario:
          salvaCarrinhoOutroUsuario ?? this.salvaCarrinhoOutroUsuario,
      editaCarrinhoOutroUsuario:
          editaCarrinhoOutroUsuario ?? this.editaCarrinhoOutroUsuario,
      excluiCarrinhoOutroUsuario:
          excluiCarrinhoOutroUsuario ?? this.excluiCarrinhoOutroUsuario,
    );
  }

  factory UsuarioConsultaMoldel.fromJson(Map<String, dynamic> map) {
    return UsuarioConsultaMoldel(
      codEmpresa: map['CodEmpresa'],
      codUsuario: map['CodUsuario'],
      nomeUsuario: map['NomeUsuario'],
      ativo: map['Ativo'],
      codContaFinanceira: map['CodContaFinanceira'],
      nomeContaFinanceira: map['NomeContaFinanceira'],
      nomeCaixaOperador: map['NomeCaixaOperador'],
      codLocalArmazenagem: map['CodLocalArmazenagem'],
      nomeLocalArmazenagem: map['NomeLocalArmazenagem'],
      codVendedor: map['CodVendedor'],
      nomeVendedor: map['NomeVendedor'],
      codSetorEstoque: map['CodSetorEstoque'],
      descricaoSetorEstoque: map['DescricaoSetorEstoque'],
      permiteSepararForaSequencia: map['PermiteSepararForaSequencia'],
      visualizaTodasSeparacoes: map['VisualizaTodasSeparacoes'],
      codSetorConferencia: map['CodSetorConferencia'],
      descricaoSetorConferencia: map['DescricaoSetorConferencia'],
      permiteConferirForaSequencia: map['PermiteConferirForaSequencia'],
      visualizaTodasConferencias: map['VisualizaTodasConferencias'],
      salvaCarrinhoOutroUsuario: map['SalvaCarrinhoOutroUsuario'],
      editaCarrinhoOutroUsuario: map['EditaCarrinhoOutroUsuario'],
      excluiCarrinhoOutroUsuario: map['ExcluiCarrinhoOutroUsuario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodUsuario': codUsuario,
      'NomeUsuario': nomeUsuario,
      'Ativo': ativo,
      'CodContaFinanceira': codContaFinanceira,
      'NomeContaFinanceira': nomeContaFinanceira,
      'NomeCaixaOperador': nomeCaixaOperador,
      'CodLocalArmazenagem': codLocalArmazenagem,
      'NomeLocalArmazenagem': nomeLocalArmazenagem,
      'CodVendedor': codVendedor,
      'NomeVendedor': nomeVendedor,
      'CodSetorEstoque': codSetorEstoque,
      'DescricaoSetorEstoque': descricaoSetorEstoque,
      'PermiteSepararForaSequencia': permiteSepararForaSequencia,
      'VisualizaTodasSeparacoes': visualizaTodasSeparacoes,
      'CodSetorConferencia': codSetorConferencia,
      'DescricaoSetorConferencia': descricaoSetorConferencia,
      'PermiteConferirForaSequencia': permiteConferirForaSequencia,
      'VisualizaTodasConferencias': visualizaTodasConferencias,
      'SalvaCarrinhoOutroUsuario': salvaCarrinhoOutroUsuario,
      'EditaCarrinhoOutroUsuario': editaCarrinhoOutroUsuario,
      'ExcluiCarrinhoOutroUsuario': excluiCarrinhoOutroUsuario,
    };
  }

  @override
  String toString() {
    return '''
      UsuarioConsultaMoldel(
        codEmpresa: $codEmpresa, 
        codUsuario: $codUsuario, 
        nomeUsuario: $nomeUsuario, 
        ativo: $ativo, 
        codContaFinanceira: $codContaFinanceira, 
        nomeContaFinanceira: $nomeContaFinanceira, 
        nomeCaixaOperador: $nomeCaixaOperador, 
        codLocalArmazenagem: $codLocalArmazenagem, 
        nomeLocalArmazenagem: $nomeLocalArmazenagem, 
        codVendedor: $codVendedor, 
        nomeVendedor: $nomeVendedor, 
        codSetorEstoque: $codSetorEstoque, 
        descricaoSetorEstoque: $descricaoSetorEstoque, 
        permiteSepararForaSequencia: $permiteSepararForaSequencia, 
        visualizaTodasSeparacoes: $visualizaTodasSeparacoes, 
        codSetorConferencia: $codSetorConferencia, 
        descricaoSetorConferencia: $descricaoSetorConferencia, 
        permiteConferirForaSequencia: $permiteConferirForaSequencia, 
        visualizaTodasConferencias: $visualizaTodasConferencias, 
        salvaCarrinhoOutroUsuario: $salvaCarrinhoOutroUsuario, 
        editaCarrinhoOutroUsuario: $editaCarrinhoOutroUsuario, 
        excluiCarrinhoOutroUsuario: $excluiCarrinhoOutroUsuario
      )''';
  }
}
