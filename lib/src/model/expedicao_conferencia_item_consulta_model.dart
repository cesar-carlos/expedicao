import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaConferenciaItemConsultaModel {
  final int codEmpresa;
  final int codConferir;
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
  final String? codigoBarras;
  final String? codigoBarras2;
  final String? codigoReferencia;
  final String? codigoFornecedor;
  final String? codigoFabricante;
  final String? codigoOriginal;
  final String? endereco;
  final String? enderecoDescricao;
  final int codConferente;
  final String nomeConferente;
  final DateTime dataConferencia;
  final String horaConferencia;
  final double quantidade;

  ExpedicaConferenciaItemConsultaModel({
    required this.codEmpresa,
    required this.codConferir,
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
    this.codigoBarras,
    this.codigoBarras2,
    this.codigoReferencia,
    this.codigoFornecedor,
    this.codigoFabricante,
    this.codigoOriginal,
    this.endereco,
    this.enderecoDescricao,
    required this.codConferente,
    required this.nomeConferente,
    required this.dataConferencia,
    required this.horaConferencia,
    required this.quantidade,
  });

  ExpedicaConferenciaItemConsultaModel copyWith({
    int? codEmpresa,
    int? codConferir,
    String? item,
    String? sessionId,
    String? situacao,
    int? codCarrinho,
    String? nomeCarrinho,
    String? codigoBarrasCarrinho,
    int? codCarrinhoPercurso,
    String? itemCarrinhoPercurso,
    int? codProduto,
    String? nomeProduto,
    String? codUnidadeMedida,
    String? nomeUnidadeMedida,
    int? codGrupoProduto,
    String? nomeGrupoProduto,
    int? codMarca,
    String? nomeMarca,
    String? codigoBarras,
    String? codigoBarras2,
    String? codigoReferencia,
    String? codigoFornecedor,
    String? codigoFabricante,
    String? codigoOriginal,
    String? endereco,
    String? enderecoDescricao,
    int? codConferente,
    String? nomeConferente,
    DateTime? dataConferencia,
    String? horaConferencia,
    double? quantidade,
  }) {
    return ExpedicaConferenciaItemConsultaModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codConferir: codConferir ?? this.codConferir,
      item: item ?? this.item,
      sessionId: sessionId ?? this.sessionId,
      situacao: situacao ?? this.situacao,
      codCarrinho: codCarrinho ?? this.codCarrinho,
      nomeCarrinho: nomeCarrinho ?? this.nomeCarrinho,
      codigoBarrasCarrinho: codigoBarrasCarrinho ?? this.codigoBarrasCarrinho,
      codCarrinhoPercurso: codCarrinhoPercurso ?? this.codCarrinhoPercurso,
      itemCarrinhoPercurso: itemCarrinhoPercurso ?? this.itemCarrinhoPercurso,
      codProduto: codProduto ?? this.codProduto,
      nomeProduto: nomeProduto ?? this.nomeProduto,
      codUnidadeMedida: codUnidadeMedida ?? this.codUnidadeMedida,
      nomeUnidadeMedida: nomeUnidadeMedida ?? this.nomeUnidadeMedida,
      codGrupoProduto: codGrupoProduto ?? this.codGrupoProduto,
      nomeGrupoProduto: nomeGrupoProduto ?? this.nomeGrupoProduto,
      codMarca: codMarca ?? this.codMarca,
      nomeMarca: nomeMarca ?? this.nomeMarca,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      codigoBarras2: codigoBarras2 ?? this.codigoBarras2,
      codigoReferencia: codigoReferencia ?? this.codigoReferencia,
      codigoFornecedor: codigoFornecedor ?? this.codigoFornecedor,
      codigoFabricante: codigoFabricante ?? this.codigoFabricante,
      codigoOriginal: codigoOriginal ?? this.codigoOriginal,
      endereco: endereco ?? this.endereco,
      enderecoDescricao: enderecoDescricao ?? this.enderecoDescricao,
      codConferente: codConferente ?? this.codConferente,
      nomeConferente: nomeConferente ?? this.nomeConferente,
      dataConferencia: dataConferencia ?? this.dataConferencia,
      horaConferencia: horaConferencia ?? this.horaConferencia,
      quantidade: quantidade ?? this.quantidade,
    );
  }

  factory ExpedicaConferenciaItemConsultaModel.fromJson(Map map) {
    return ExpedicaConferenciaItemConsultaModel(
      codEmpresa: map['CodEmpresa'],
      codConferir: map['CodConferir'],
      item: map['Item'],
      sessionId: map['SessionId'],
      situacao: map['Situacao'],
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
      codigoBarras: map['CodigoBarras'],
      codigoBarras2: map['CodigoBarras2'],
      codigoReferencia: map['CodigoReferencia'],
      codigoFornecedor: map['CodigoFornecedor'],
      codigoFabricante: map['CodigoFabricante'],
      codigoOriginal: map['CodigoOriginal'],
      endereco: map['Endereco'],
      enderecoDescricao: map['EnderecoDescricao'],
      codConferente: map['CodConferente'],
      nomeConferente: map['NomeConferente'],
      dataConferencia: AppHelper.tryStringToDate(map['DataConferencia']),
      horaConferencia: map['HoraConferencia'] ?? '00:00:00',
      quantidade: AppHelper.stringToDouble(map['Quantidade']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodConferir': codConferir,
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
      'CodigoBarras': codigoBarras,
      'CodigoBarras2': codigoBarras2,
      'CodigoReferencia': codigoReferencia,
      'CodigoFornecedor': codigoFornecedor,
      'CodigoFabricante': codigoFabricante,
      'CodigoOriginal': codigoOriginal,
      'Endereco': endereco,
      'EnderecoDescricao': enderecoDescricao,
      'CodConferente': codConferente,
      'NomeConferente': nomeConferente,
      'DataConferencia': dataConferencia,
      'HoraConferencia': horaConferencia,
      'Quantidade': quantidade.toStringAsFixed(4),
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaConferenciaItemConsultaModel(
        codEmpresa: $codEmpresa, 
        codConferir: $codConferir, 
        item: $item, 
        sessionId: $sessionId, 
        situacao: $situacao, 
        codCarrinho: $codCarrinho, 
        nomeCarrinho: $nomeCarrinho, 
        codigoBarrasCarrinho: $codigoBarrasCarrinho, 
        codCarrinhoPercurso: $codCarrinhoPercurso, 
        itemCarrinhoPercurso: $itemCarrinhoPercurso, 
        codProduto: $codProduto, 
        nomeProduto: $nomeProduto, 
        codUnidadeMedida: $codUnidadeMedida, 
        nomeUnidadeMedida: $nomeUnidadeMedida, 
        codGrupoProduto: $codGrupoProduto, 
        nomeGrupoProduto: $nomeGrupoProduto, 
        codMarca: $codMarca, 
        nomeMarca: $nomeMarca, 
        codigoBarras: $codigoBarras, 
        codigoBarras2: $codigoBarras2, 
        codigoReferencia: $codigoReferencia, 
        codigoFornecedor: $codigoFornecedor, 
        codigoFabricante: $codigoFabricante, 
        codigoOriginal: $codigoOriginal, 
        endereco: $endereco, 
        enderecoDescricao: $enderecoDescricao, 
        codConferente: $codConferente, 
        nomeConferente: $nomeConferente, 
        dataConferencia: $dataConferencia, 
        horaConferencia: $horaConferencia, 
        quantidade: $quantidade)
    ''';
  }
}
