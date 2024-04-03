class ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel {
  final int codEmpresa;
  final int codCarrinhoPercurso;
  final String? itemAgrupamento;
  final String itemCarrinhoPercurso;
  final String origem;
  final int codOrigem;
  final String situacao;
  final String situacaoPercurso;
  final int? codPercursoEstagio;
  final String? descricaoPercursoEstagio;
  final int? codCarrinhoAgrupador;
  final int codCarrinho;
  final String nomeCarrinho;
  final String codigoBarrasCarrinho;
  final String carrinhoAgrupador;
  final String? nomeCarrinhoAgrupador;
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
    required this.codOrigem,
    required this.situacao,
    required this.situacaoPercurso,
    this.codPercursoEstagio,
    this.descricaoPercursoEstagio,
    this.codCarrinhoAgrupador,
    this.nomeCarrinhoAgrupador,
    required this.codCarrinho,
    required this.nomeCarrinho,
    required this.codigoBarrasCarrinho,
    required this.carrinhoAgrupador,
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
      int? codOrigem,
      String? situacao,
      String? situacaoPercurso,
      int? codPercursoEstagio,
      String? descricaoPercursoEstagio,
      int? codCarrinhoAgrupador,
      String? nomeCarrinhoAgrupador,
      int? codCarrinho,
      String? nomeCarrinho,
      String? codigoBarrasCarrinho,
      String? carrinhoAgrupador,
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
      codOrigem: codOrigem ?? this.codOrigem,
      situacao: situacao ?? this.situacao,
      situacaoPercurso: situacaoPercurso ?? this.situacaoPercurso,
      codPercursoEstagio: codPercursoEstagio ?? this.codPercursoEstagio,
      descricaoPercursoEstagio:
          descricaoPercursoEstagio ?? this.descricaoPercursoEstagio,
      codCarrinhoAgrupador: codCarrinhoAgrupador ?? this.codCarrinhoAgrupador,
      nomeCarrinhoAgrupador:
          nomeCarrinhoAgrupador ?? this.nomeCarrinhoAgrupador,
      codCarrinho: codCarrinho ?? this.codCarrinho,
      nomeCarrinho: nomeCarrinho ?? this.nomeCarrinho,
      codigoBarrasCarrinho: codigoBarrasCarrinho ?? this.codigoBarrasCarrinho,
      carrinhoAgrupador: carrinhoAgrupador ?? this.carrinhoAgrupador,
      dataInicio: dataInicio ?? this.dataInicio,
      horaInicio: horaInicio ?? this.horaInicio,
      codUsuarioInicio: codUsuarioInicio ?? this.codUsuarioInicio,
      nomeUsuarioInicio: nomeUsuarioInicio ?? this.nomeUsuarioInicio,
    );
  }

  factory ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel.fromJson(
      Map<String, dynamic> json) {
    try {
      return ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel(
        codEmpresa: json['CodEmpresa'],
        codCarrinhoPercurso: json['CodCarrinhoPercurso'],
        itemAgrupamento: json['ItemAgrupamento'],
        itemCarrinhoPercurso: json['ItemCarrinhoPercurso'],
        origem: json['Origem'],
        codOrigem: json['CodOrigem'],
        situacao: json['Situacao'],
        situacaoPercurso: json['SituacaoPercurso'],
        codPercursoEstagio: json['CodPercursoEstagio'],
        descricaoPercursoEstagio: json['DescricaoPercursoEstagio'],
        codCarrinhoAgrupador: json['CodCarrinhoAgrupador'],
        nomeCarrinhoAgrupador: json['NomeCarrinhoAgrupador'],
        codCarrinho: json['CodCarrinho'],
        nomeCarrinho: json['NomeCarrinho'],
        codigoBarrasCarrinho: json['CodigoBarrasCarrinho'],
        carrinhoAgrupador: json['CarrinhoAgrupador'],
        dataInicio: DateTime.parse(json['DataInicio']),
        horaInicio: json['HoraInicio'],
        codUsuarioInicio: json['CodUsuarioInicio'],
        nomeUsuarioInicio: json['NomeUsuarioInicio'],
      );
    } catch (_) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'ItemAgrupamento': itemAgrupamento,
      'ItemCarrinhoPercurso': itemCarrinhoPercurso,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'Situacao': situacao,
      'SituacaoPercurso': situacaoPercurso,
      'CodPercursoEstagio': codPercursoEstagio,
      'DescricaoPercursoEstagio': descricaoPercursoEstagio,
      'CodCarrinhoAgrupador': codCarrinhoAgrupador,
      'NomeCarrinhoAgrupador': nomeCarrinhoAgrupador,
      'CodCarrinho': codCarrinho,
      'NomeCarrinho': nomeCarrinho,
      'CodigoBarrasCarrinho': codigoBarrasCarrinho,
      'CarrinhoAgrupador': carrinhoAgrupador,
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
        codOrigem: $codOrigem,
        situacao: $situacao, 
        situacaoPercurso: $situacaoPercurso,
        codCarrinhoAgrupador: $codCarrinhoAgrupador, 
        nomeCarrinhoAgrupador: $nomeCarrinhoAgrupador, 
        codCarrinho: $codCarrinho, 
        nomeCarrinho: $nomeCarrinho, 
        codigoBarrasCarrinho: $codigoBarrasCarrinho,
        carrinhoAgrupador: $carrinhoAgrupador,
        dataInicio: $dataInicio, 
        horaInicio: $horaInicio, 
        codUsuarioInicio: $codUsuarioInicio, 
        nomeUsuarioInicio: $nomeUsuarioInicio
    )''';
  }
}
