class ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel {
  final int codEmpresa;
  final int codCarrinhoPercurso;
  final String? itemAgrupamento;
  final String itemCarrinhoPercurso;
  final String origem;
  final String situacao;
  final int? codCarrinhoAgrupador;
  final String? nomeCarrinhoAgrupador;
  final int codCarrinho;
  final String nomeCarrinho;
  final String codigoBarrasCarrinho;
  final DateTime dataInicio;
  final String horaInicio;
  final int codUsuarioInicio;
  final String nomeUsuarioInicio;

  ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel({
    required this.codEmpresa,
    required this.codCarrinhoPercurso,
    this.itemAgrupamento,
    required this.itemCarrinhoPercurso,
    required this.origem,
    required this.situacao,
    this.codCarrinhoAgrupador,
    this.nomeCarrinhoAgrupador,
    required this.codCarrinho,
    required this.nomeCarrinho,
    required this.codigoBarrasCarrinho,
    required this.dataInicio,
    required this.horaInicio,
    required this.codUsuarioInicio,
    required this.nomeUsuarioInicio,
  });

  ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel copyWith(
      {int? codEmpresa,
      int? codCarrinhoPercurso,
      String? itemAgrupamento,
      String? itemCarrinhoPercurso,
      String? origem,
      String? situacao,
      int? codCarrinhoAgrupador,
      String? nomeCarrinhoAgrupador,
      int? codCarrinho,
      String? nomeCarrinho,
      String? codigoBarrasCarrinho,
      DateTime? dataInicio,
      String? horaInicio,
      int? codUsuarioInicio,
      String? nomeUsuarioInicio}) {
    return ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codCarrinhoPercurso: codCarrinhoPercurso ?? this.codCarrinhoPercurso,
      itemAgrupamento: itemAgrupamento ?? this.itemAgrupamento,
      itemCarrinhoPercurso: itemCarrinhoPercurso ?? this.itemCarrinhoPercurso,
      origem: origem ?? this.origem,
      situacao: situacao ?? this.situacao,
      codCarrinhoAgrupador: codCarrinhoAgrupador ?? this.codCarrinhoAgrupador,
      nomeCarrinhoAgrupador:
          nomeCarrinhoAgrupador ?? this.nomeCarrinhoAgrupador,
      codCarrinho: codCarrinho ?? this.codCarrinho,
      nomeCarrinho: nomeCarrinho ?? this.nomeCarrinho,
      codigoBarrasCarrinho: codigoBarrasCarrinho ?? this.codigoBarrasCarrinho,
      dataInicio: dataInicio ?? this.dataInicio,
      horaInicio: horaInicio ?? this.horaInicio,
      codUsuarioInicio: codUsuarioInicio ?? this.codUsuarioInicio,
      nomeUsuarioInicio: nomeUsuarioInicio ?? this.nomeUsuarioInicio,
    );
  }

  factory ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel.fromJson(
      Map<String, dynamic> map) {
    return ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel(
      codEmpresa: map['CodEmpresa'],
      codCarrinhoPercurso: map['CodCarrinhoPercurso'],
      itemAgrupamento: map['ItemAgrupamento'],
      itemCarrinhoPercurso: map['ItemCarrinhoPercurso'],
      origem: map['Origem'],
      situacao: map['Situacao'],
      codCarrinhoAgrupador: map['CodCarrinhoAgrupador'],
      nomeCarrinhoAgrupador: map['NomeCarrinhoAgrupador'],
      codCarrinho: map['CodCarrinho'],
      nomeCarrinho: map['NomeCarrinho'],
      codigoBarrasCarrinho: map['CodigoBarrasCarrinho'],
      dataInicio: DateTime.parse(map['DataInicio']),
      horaInicio: map['HoraInicio'],
      codUsuarioInicio: map['CodUsuarioInicio'],
      nomeUsuarioInicio: map['NomeUsuarioInicio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'ItemAgrupamento': itemAgrupamento,
      'ItemCarrinhoPercurso': itemCarrinhoPercurso,
      'Origem': origem,
      'Situacao': situacao,
      'CodCarrinhoAgrupador': codCarrinhoAgrupador,
      'NomeCarrinhoAgrupador': nomeCarrinhoAgrupador,
      'CodCarrinho': codCarrinho,
      'NomeCarrinho': nomeCarrinho,
      'CodigoBarrasCarrinho': codigoBarrasCarrinho,
      'DataInicio': dataInicio.toIso8601String(),
      'HoraInicio': horaInicio,
      'CodUsuarioInicio': codUsuarioInicio,
      'NomeUsuarioInicio': nomeUsuarioInicio,
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel(
        codEmpresa: $codEmpresa, 
        codCarrinhoPercurso: $codCarrinhoPercurso, 
        itemCarrinhoPercurso: $itemCarrinhoPercurso, 
        itemAgrupamento: $itemAgrupamento, 
        origem: $origem, 
        situacao: $situacao, 
        codCarrinhoAgrupador: $codCarrinhoAgrupador, 
        nomeCarrinhoAgrupador: $nomeCarrinhoAgrupador, 
        codCarrinho: $codCarrinho, 
        nomeCarrinho: $nomeCarrinho, 
        codigoBarrasCarrinho: $codigoBarrasCarrinho,
        dataInicio: $dataInicio, 
        horaInicio: $horaInicio, 
        codUsuarioInicio: $codUsuarioInicio, 
        nomeUsuarioInicio: $nomeUsuarioInicio
      )
    ''';
  }
}
