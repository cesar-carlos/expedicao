import 'package:app_expedicao/src/model/basic_model.dart';

class ExpedicaoCarrinhoModel implements BasicModel {
  final int codEmpresa;
  final int codCarrinho;
  final String descricao;
  final String ativo;
  final String codigoBarras;
  final String situacao;

  ExpedicaoCarrinhoModel({
    required this.codEmpresa,
    required this.codCarrinho,
    required this.descricao,
    required this.ativo,
    required this.codigoBarras,
    required this.situacao,
  });

  @override
  ExpedicaoCarrinhoModel copyWith({
    int? codEmpresa,
    int? codCarrinho,
    String? descricao,
    String? ativo,
    String? codigoBarras,
    String? situacao,
  }) {
    return ExpedicaoCarrinhoModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codCarrinho: codCarrinho ?? this.codCarrinho,
      descricao: descricao ?? this.descricao,
      ativo: ativo ?? this.ativo,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      situacao: situacao ?? this.situacao,
    );
  }

  @override
  factory ExpedicaoCarrinhoModel.fromJson(Map<String, dynamic> map) {
    return ExpedicaoCarrinhoModel(
      codEmpresa: map['CodEmpresa'],
      codCarrinho: map['CodCarrinho'],
      descricao: map['Descricao'],
      ativo: map['Ativo'],
      codigoBarras: map['CodigoBarras'],
      situacao: map['Situacao'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodCarrinho': codCarrinho,
      'Descricao': descricao,
      'Ativo': ativo,
      'CodigoBarras': codigoBarras,
      'Situacao': situacao,
    };
  }

  @override
  String toString() {
    return 'ExpedicaoCarrinhoModel(codEmpresa: $codEmpresa, codCarrinho: $codCarrinho, descricao: $descricao, ativo: $ativo, codigoBarras: $codigoBarras, situacao: $situacao)';
  }
}
