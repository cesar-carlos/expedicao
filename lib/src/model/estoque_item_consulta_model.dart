class EstoqueItemConsultaModel {
  final int codProduto;
  final int nomeProduto;
  final int ativo;
  final int codTipoProduto;
  final int codUnidadeMedida;
  final int nomeUnidadeMedida;
  final int codGrupoProduto;
  final int nomeGrupoProduto;
  final int codMarca;
  final int nomeMarca;
  final int codSetorEstoque;
  final int ncm;
  final int codigoBarras;
  final int codigoBarras2;
  final int codigoReferencia;
  final int codigoFornecedor;
  final int codigoFabricante;
  final int codigoOriginal;
  final int endereco;

  EstoqueItemConsultaModel({
    required this.codProduto,
    required this.nomeProduto,
    required this.ativo,
    required this.codTipoProduto,
    required this.codUnidadeMedida,
    required this.nomeUnidadeMedida,
    required this.codGrupoProduto,
    required this.nomeGrupoProduto,
    required this.codMarca,
    required this.nomeMarca,
    required this.codSetorEstoque,
    required this.ncm,
    required this.codigoBarras,
    required this.codigoBarras2,
    required this.codigoReferencia,
    required this.codigoFornecedor,
    required this.codigoFabricante,
    required this.codigoOriginal,
    required this.endereco,
  });

  factory EstoqueItemConsultaModel.fromJson(Map map) {
    return EstoqueItemConsultaModel(
      codProduto: int.parse(map['CodProduto']),
      nomeProduto: map['NomeProduto'],
      ativo: map['Ativo'],
      codTipoProduto: map['CodTipoProduto'],
      codUnidadeMedida: map['CodUnidadeMedida'],
      nomeUnidadeMedida: map['NomeUnidadeMedida'],
      codGrupoProduto: map['CodGrupoProduto'],
      nomeGrupoProduto: map['NomeGrupoProduto'],
      codMarca: map['CodMarca'],
      nomeMarca: map['NomeMarca'],
      codSetorEstoque: map['CodSetorEstoque'],
      ncm: map['NCM'],
      codigoBarras: map['CodigoBarras'],
      codigoBarras2: map['CodigoBarras2'],
      codigoReferencia: map['CodigoReferencia'],
      codigoFornecedor: map['CodigoFornecedor'],
      codigoFabricante: map['CodigoFabricante'],
      codigoOriginal: map['CodigoOriginal'],
      endereco: map['Endereco'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodProduto': codProduto,
      'NomeProduto': nomeProduto,
      'Ativo': ativo,
      'CodTipoProduto': codTipoProduto,
      'CodUnidadeMedida': codUnidadeMedida,
      'NomeUnidadeMedida': nomeUnidadeMedida,
      'CodGrupoProduto': codGrupoProduto,
      'NomeGrupoProduto': nomeGrupoProduto,
      'CodMarca': codMarca,
      'NomeMarca': nomeMarca,
      'CodSetorEstoque': codSetorEstoque,
      'NCM': ncm,
      'CodigoBarras': codigoBarras,
      'CodigoBarras2': codigoBarras2,
      'CodigoReferencia': codigoReferencia,
      'CodigoFornecedor': codigoFornecedor,
      'CodigoFabricante': codigoFabricante,
      'CodigoOriginal': codigoOriginal,
      'Endereco': endereco,
    };
  }
}
