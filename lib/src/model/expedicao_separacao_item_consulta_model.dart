import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaSeparacaoItemConsultaModel {
  final int codEmpresa;
  final int codSepararEstoque;
  final String item;
  final String sessionId;
  final String situacao;
  final int codCarrinho;
  final String nomeCarrinho;
  final String codigoBarrasCarrinho;
  final int codCarrinhoPercurso;
  final String itemCarrinhoPercurso;
  final int codProduto;
  final String nomeProduto;
  final String codUnidadeMedida;
  final String nomeUnidadeMedida;
  final int codGrupoProduto;
  final String nomeGrupoProduto;
  final int? codMarca;
  final String? nomeMarca;
  final int? codSetorEstoque;
  final String? nomeSetorEstoque;
  final String ncm;
  final String? codigoBarras;
  final String? codigoBarras2;
  final String? codigoReferencia;
  final String? codigoFornecedor;
  final String? codigoFabricante;
  final String? codigoOriginal;
  final String? endereco;
  final int codSeparador;
  final String nomeSeparador;
  final DateTime dataSeparacao;
  final String horaSeparacao;
  final double quantidade;

  ExpedicaSeparacaoItemConsultaModel({
    required this.codEmpresa,
    required this.codSepararEstoque,
    required this.item,
    required this.sessionId,
    required this.situacao,
    required this.codCarrinho,
    required this.nomeCarrinho,
    required this.codigoBarrasCarrinho,
    required this.codCarrinhoPercurso,
    required this.itemCarrinhoPercurso,
    required this.codProduto,
    required this.nomeProduto,
    required this.codUnidadeMedida,
    required this.nomeUnidadeMedida,
    required this.codGrupoProduto,
    required this.nomeGrupoProduto,
    this.codMarca,
    this.nomeMarca,
    this.codSetorEstoque,
    this.nomeSetorEstoque,
    required this.ncm,
    this.codigoBarras,
    this.codigoBarras2,
    this.codigoReferencia,
    this.codigoFornecedor,
    this.codigoFabricante,
    this.codigoOriginal,
    this.endereco,
    required this.codSeparador,
    required this.nomeSeparador,
    required this.dataSeparacao,
    required this.horaSeparacao,
    required this.quantidade,
  });

  factory ExpedicaSeparacaoItemConsultaModel.fromJson(
      Map<String, dynamic> map) {
    return ExpedicaSeparacaoItemConsultaModel(
      codEmpresa: map['CodEmpresa'],
      codSepararEstoque: map['CodSepararEstoque'],
      item: map['Item'],
      sessionId: map['SessionId'],
      situacao: map['Situacao'] ?? '',
      codCarrinho: map['CodCarrinho'],
      nomeCarrinho: map['NomeCarrinho'],
      codigoBarrasCarrinho: map['CodigoBarrasCarrinho'],
      codCarrinhoPercurso: map['CodCarrinhoPercurso'],
      itemCarrinhoPercurso: map['ItemCarrinhoPercurso'],
      codProduto: map['CodProduto'],
      nomeProduto: map['NomeProduto'],
      codUnidadeMedida: map['CodUnidadeMedida'],
      nomeUnidadeMedida: map['NomeUnidadeMedida'],
      codGrupoProduto: map['CodGrupoProduto'],
      nomeGrupoProduto: map['NomeGrupoProduto'],
      codMarca: map['CodMarca'],
      nomeMarca: map['NomeMarca'],
      codSetorEstoque: map['CodSetorEstoque'],
      nomeSetorEstoque: map['NomeSetorEstoque'],
      ncm: map['NCM'] ?? '00000000',
      codigoBarras: map['CodigoBarras'],
      codigoBarras2: map['CodigoBarras2'],
      codigoReferencia: map['CodigoReferencia'],
      codigoFornecedor: map['CodigoFornecedor'],
      codigoFabricante: map['CodigoFabricante'],
      codigoOriginal: map['CodigoOriginal'],
      endereco: map['Endereco'],
      codSeparador: map['CodSeparador'],
      nomeSeparador: map['NomeSeparador'],
      dataSeparacao: AppHelper.tryStringToDate(map['DataSeparacao']),
      horaSeparacao: map['HoraSeparacao'],
      quantidade: AppHelper.stringToDouble(map['Quantidade']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodSepararEstoque': codSepararEstoque,
      'Item': item,
      'SessionId': sessionId,
      'Situacao': situacao,
      'CodCarrinho': codCarrinho,
      'NomeCarrinho': nomeCarrinho,
      'CodigoBarrasCarrinho': codigoBarrasCarrinho,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'ItemCarrinhoPercurso': itemCarrinhoPercurso,
      'CodProduto': codProduto,
      'NomeProduto': nomeProduto,
      'CodUnidadeMedida': codUnidadeMedida,
      'NomeUnidadeMedida': nomeUnidadeMedida,
      'CodGrupoProduto': codGrupoProduto,
      'NomeGrupoProduto': nomeGrupoProduto,
      'CodMarca': codMarca,
      'NomeMarca': nomeMarca,
      'CodSetorEstoque': codSetorEstoque,
      'NomeSetorEstoque': nomeSetorEstoque,
      'NCM': ncm,
      'CodigoBarras': codigoBarras,
      'CodigoBarras2': codigoBarras2,
      'CodigoReferencia': codigoReferencia,
      'CodigoFornecedor': codigoFornecedor,
      'CodigoFabricante': codigoFabricante,
      'CodigoOriginal': codigoOriginal,
      'Endereco': endereco,
      'CodSeparador': codSeparador,
      'NomeSeparador': nomeSeparador,
      'DataSeparacao': dataSeparacao.toIso8601String(),
      'HoraSeparacao': horaSeparacao,
      'Quantidade': quantidade.toStringAsFixed(4),
    };
  }

  @override
  String toString() {
    return 'ExpedicaSeparacaoItemConsultaModel(codEmpresa: $codEmpresa, codSepararEstoque: $codSepararEstoque, item: $item, sessionId: $sessionId, situacao: $situacao, codCarrinho: $codCarrinho, nomeCarrinho: $nomeCarrinho, codigoBarrasCarrinho: $codigoBarrasCarrinho, codCarrinhoPercurso: $codCarrinhoPercurso, itemCarrinhoPercurso: $itemCarrinhoPercurso, codProduto: $codProduto, nomeProduto: $nomeProduto, codUnidadeMedida: $codUnidadeMedida, nomeUnidadeMedida: $nomeUnidadeMedida, codGrupoProduto: $codGrupoProduto, nomeGrupoProduto: $nomeGrupoProduto, codMarca: $codMarca, nomeMarca: $nomeMarca, codSetorEstoque: $codSetorEstoque, nomeSetorEstoque: $nomeSetorEstoque, ncm: $ncm, codigoBarras: $codigoBarras, codigoBarras2: $codigoBarras2, codigoReferencia: $codigoReferencia, codigoFornecedor: $codigoFornecedor, codigoFabricante: $codigoFabricante, codigoOriginal: $codigoOriginal, endereco: $endereco, codSeparador: $codSeparador, nomeSeparador: $nomeSeparador, dataSeparacao: $dataSeparacao, horaSeparacao: $horaSeparacao, quantidade: $quantidade)';
  }
}
