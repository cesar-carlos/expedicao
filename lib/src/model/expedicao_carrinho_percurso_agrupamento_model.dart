class ExpedicaoCarrinhoPercursoAgrupamentoModel {
  final int codEmpresa;
  final int codCarrinhoPercurso;
  final String item;
  final String origem;
  final String itemCarrinhoPercurso;
  final String situacao;
  final int codCarrinhoAgrupador;
  final DateTime dataLancamento;
  final String horaLancamento;
  final int codUsuarioLancamento;
  final String nomeUsuarioLancamento;

  ExpedicaoCarrinhoPercursoAgrupamentoModel({
    required this.codEmpresa,
    required this.codCarrinhoPercurso,
    required this.item,
    required this.origem,
    required this.itemCarrinhoPercurso,
    required this.situacao,
    required this.codCarrinhoAgrupador,
    required this.dataLancamento,
    required this.horaLancamento,
    required this.codUsuarioLancamento,
    required this.nomeUsuarioLancamento,
  });

  ExpedicaoCarrinhoPercursoAgrupamentoModel copyWith(
      {int? codEmpresa,
      int? codCarrinhoPercurso,
      String? item,
      String? origem,
      String? itemCarrinhoPercurso,
      String? situacao,
      int? codCarrinhoAgrupador,
      DateTime? dataLancamento,
      String? horaLancamento,
      int? codUsuarioLancamento,
      String? nomeUsuarioLancamento}) {
    return ExpedicaoCarrinhoPercursoAgrupamentoModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codCarrinhoPercurso: codCarrinhoPercurso ?? this.codCarrinhoPercurso,
      item: item ?? this.item,
      origem: origem ?? this.origem,
      itemCarrinhoPercurso: itemCarrinhoPercurso ?? this.itemCarrinhoPercurso,
      situacao: situacao ?? this.situacao,
      codCarrinhoAgrupador: codCarrinhoAgrupador ?? this.codCarrinhoAgrupador,
      dataLancamento: dataLancamento ?? this.dataLancamento,
      horaLancamento: horaLancamento ?? this.horaLancamento,
      codUsuarioLancamento: codUsuarioLancamento ?? this.codUsuarioLancamento,
      nomeUsuarioLancamento:
          nomeUsuarioLancamento ?? this.nomeUsuarioLancamento,
    );
  }

  factory ExpedicaoCarrinhoPercursoAgrupamentoModel.fromJson(
      Map<String, dynamic> map) {
    return ExpedicaoCarrinhoPercursoAgrupamentoModel(
      codEmpresa: map['CodEmpresa'],
      codCarrinhoPercurso: map['CodCarrinhoPercurso'],
      item: map['Item'],
      origem: map['Origem'],
      itemCarrinhoPercurso: map['ItemCarrinhoPercurso'],
      situacao: map['Situacao'],
      codCarrinhoAgrupador: map['CodCarrinhoAgrupador'],
      dataLancamento: DateTime.parse(map['DataLancamento']),
      horaLancamento: map['HoraLancamento'],
      codUsuarioLancamento: map['CodUsuarioLancamento'],
      nomeUsuarioLancamento: map['NomeUsuarioLancamento'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'Item': item,
      'Origem': origem,
      'ItemCarrinhoPercurso': itemCarrinhoPercurso,
      'Situacao': situacao,
      'CodCarrinhoAgrupador': codCarrinhoAgrupador,
      'DataLancamento': dataLancamento.toIso8601String(),
      'HoraLancamento': horaLancamento,
      'CodUsuarioLancamento': codUsuarioLancamento,
      'NomeUsuarioLancamento': nomeUsuarioLancamento,
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoCarrinhoPercursoAgrupamentoModel(
        codEmpresa: $codEmpresa, 
        codCarrinhoPercurso: $codCarrinhoPercurso, 
        item: $item, 
        origem: $origem,
        itemCarrinhoPercurso: $itemCarrinhoPercurso, 
        situacao: $situacao, 
        codCarrinhoAgrupador: $codCarrinhoAgrupador, 
        dataLancamento: $dataLancamento, 
        horaLancamento: $horaLancamento, 
        codUsuarioLancamento: $codUsuarioLancamento, 
        nomeUsuarioLancamento: $nomeUsuarioLancamento)
      ''';
  }
}
