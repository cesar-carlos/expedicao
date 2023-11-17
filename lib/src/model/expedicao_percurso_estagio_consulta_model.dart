import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoPercursoEstagioConsultaModel {
  final int codEmpresa;
  final int codCarrinhoPercurso;
  final String item;
  final int codPercursoEstagio;
  final String origem;
  final int codOrigem;
  final String situacao;
  final int codCarrinho;
  final String nomeCarrinho;
  final String codigoBarrasCarrinho;
  final String ativo;
  final DateTime dataInicio;
  final String horaInicio;
  final DateTime? dataFinalizacao;
  final String? horaFinalizacao;
  final int codUsuario;
  final String nomeUsuario;
  final int? codSetorEstoque;
  final String? nomeSetorEstoque;

  ExpedicaoPercursoEstagioConsultaModel({
    required this.codEmpresa,
    required this.codCarrinhoPercurso,
    required this.item,
    required this.codPercursoEstagio,
    required this.origem,
    required this.codOrigem,
    required this.situacao,
    required this.codCarrinho,
    required this.nomeCarrinho,
    required this.codigoBarrasCarrinho,
    required this.ativo,
    required this.dataInicio,
    required this.horaInicio,
    this.dataFinalizacao,
    this.horaFinalizacao,
    required this.codUsuario,
    required this.nomeUsuario,
    this.codSetorEstoque,
    this.nomeSetorEstoque,
  });

  ExpedicaoPercursoEstagioConsultaModel copyWith({
    int? codEmpresa,
    int? codCarrinhoPercurso,
    String? item,
    int? codPercursoEstagio,
    String? origem,
    int? codOrigem,
    String? situacao,
    int? codCarrinho,
    String? nomeCarrinho,
    String? codigoBarrasCarrinho,
    String? ativo,
    DateTime? dataInicio,
    String? horaInicio,
    DateTime? dataFinalizacao,
    String? horaFinalizacao,
    int? codUsuario,
    String? nomeUsuario,
    int? codSetorEstoque,
    String? nomeSetorEstoque,
  }) {
    return ExpedicaoPercursoEstagioConsultaModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codCarrinhoPercurso: codCarrinhoPercurso ?? this.codCarrinhoPercurso,
      item: item ?? this.item,
      codPercursoEstagio: codPercursoEstagio ?? this.codPercursoEstagio,
      origem: origem ?? this.origem,
      codOrigem: codOrigem ?? this.codOrigem,
      situacao: situacao ?? this.situacao,
      codCarrinho: codCarrinho ?? this.codCarrinho,
      nomeCarrinho: nomeCarrinho ?? this.nomeCarrinho,
      codigoBarrasCarrinho: codigoBarrasCarrinho ?? this.codigoBarrasCarrinho,
      ativo: ativo ?? this.ativo,
      dataInicio: dataInicio ?? this.dataInicio,
      horaInicio: horaInicio ?? this.horaInicio,
      dataFinalizacao: dataFinalizacao ?? this.dataFinalizacao,
      horaFinalizacao: horaFinalizacao ?? this.horaFinalizacao,
      codUsuario: codUsuario ?? this.codUsuario,
      nomeUsuario: nomeUsuario ?? this.nomeUsuario,
      codSetorEstoque: codSetorEstoque ?? this.codSetorEstoque,
      nomeSetorEstoque: nomeSetorEstoque ?? this.nomeSetorEstoque,
    );
  }

  factory ExpedicaoPercursoEstagioConsultaModel.fromJson(
      Map<String, dynamic> map) {
    return ExpedicaoPercursoEstagioConsultaModel(
      codEmpresa: map['CodEmpresa'],
      codCarrinhoPercurso: map['CodCarrinhoPercurso'],
      item: map['Item'],
      codPercursoEstagio: map['CodPercursoEstagio'],
      origem: map['Origem'],
      codOrigem: map['CodOrigem'],
      situacao: map['Situacao'],
      codCarrinho: map['CodCarrinho'],
      nomeCarrinho: map['NomeCarrinho'],
      codigoBarrasCarrinho: map['CodigoBarrasCarrinho'],
      ativo: map['Ativo'],
      dataInicio: AppHelper.tryStringToDate(map['DataInicio']),
      horaInicio: map['HoraInicio'] ?? '00:00:00',
      dataFinalizacao: AppHelper.tryStringToDate(map['DataFinalizacao']),
      horaFinalizacao: map['HoraFinalizacao'],
      codUsuario: map['CodUsuario'],
      nomeUsuario: map['NomeUsuario'],
      codSetorEstoque: map['CodSetorEstoque'],
      nomeSetorEstoque: map['NomeSetorEstoque'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'Item': item,
      'CodPercursoEstagio': codPercursoEstagio,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'Situacao': situacao,
      'CodCarrinho': codCarrinho,
      'NomeCarrinho': nomeCarrinho,
      'CodigoBarrasCarrinho': codigoBarrasCarrinho,
      'Ativo': ativo,
      'DataInicio': dataInicio,
      'HoraInicio': horaInicio,
      'DataFinalizacao': dataFinalizacao,
      'HoraFinalizacao': horaFinalizacao,
      'CodUsuario': codUsuario,
      'NomeUsuario': nomeUsuario,
      'CodSetorEstoque': codSetorEstoque,
      'NomeSetorEstoque': nomeSetorEstoque,
    };
  }

  @override
  String toString() {
    return 'ExpedicaoPercursoConsultaModel(codEmpresa: $codEmpresa, codCarrinhoPercurso: $codCarrinhoPercurso, item: $item, codPercursoEstagio: $codPercursoEstagio, origem: $origem, codOrigem: $codOrigem, situacao: $situacao, codCarrinho: $codCarrinho, nomeCarrinho: $nomeCarrinho, codigoBarrasCarrinho: $codigoBarrasCarrinho, ativo: $ativo, dataInicio: $dataInicio, horaInicio: $horaInicio, dataFinalizacao: $dataFinalizacao, horaFinalizacao: $horaFinalizacao, codUsuario: $codUsuario, nomeUsuario: $nomeUsuario, codSetorEstoque: $codSetorEstoque, nomeSetorEstoque: $nomeSetorEstoque)';
  }
}
