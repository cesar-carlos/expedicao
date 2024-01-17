import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoCarrinhoPercursoConsultaModel {
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
  final int codUsuarioInicio;
  final String nomeUsuarioInicio;
  final DateTime? dataFinalizacao;
  final String? horaFinalizacao;
  final int? codSetorEstoque;
  final String? nomeSetorEstoque;
  final int? codCancelamento;
  final int? codMotivoCancelamento;
  final String? descricaoMotivoCancelamento;
  final DateTime? dataCancelamento;
  final String? horaCancelamento;
  final int? codUsuarioCancelamento;
  final String? nomeUsuarioCancelamento;
  final String? observacaoCancelamento;

  ExpedicaoCarrinhoPercursoConsultaModel({
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
    required this.codUsuarioInicio,
    required this.nomeUsuarioInicio,
    this.dataFinalizacao,
    this.horaFinalizacao,
    this.codSetorEstoque,
    this.nomeSetorEstoque,
    this.codCancelamento,
    this.codMotivoCancelamento,
    this.descricaoMotivoCancelamento,
    this.dataCancelamento,
    this.horaCancelamento,
    this.codUsuarioCancelamento,
    this.nomeUsuarioCancelamento,
    this.observacaoCancelamento,
  });

  ExpedicaoCarrinhoPercursoConsultaModel copyWith({
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
    int? codUsuarioInicio,
    String? nomeUsuarioInicio,
    DateTime? dataFinalizacao,
    String? horaFinalizacao,
    int? codSetorEstoque,
    String? nomeSetorEstoque,
    int? codCancelamento,
    int? codMotivoCancelamento,
    String? descricaoMotivoCancelamento,
    DateTime? dataCancelamento,
    String? horaCancelamento,
    int? codUsuarioCancelamento,
    String? nomeUsuarioCancelamento,
    String? observacaoCancelamento,
  }) {
    return ExpedicaoCarrinhoPercursoConsultaModel(
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
      codUsuarioInicio: codUsuarioInicio ?? this.codUsuarioInicio,
      nomeUsuarioInicio: nomeUsuarioInicio ?? this.nomeUsuarioInicio,
      dataFinalizacao: dataFinalizacao ?? this.dataFinalizacao,
      horaFinalizacao: horaFinalizacao ?? this.horaFinalizacao,
      codSetorEstoque: codSetorEstoque ?? this.codSetorEstoque,
      nomeSetorEstoque: nomeSetorEstoque ?? this.nomeSetorEstoque,
      codCancelamento: codCancelamento ?? this.codCancelamento,
      codMotivoCancelamento:
          codMotivoCancelamento ?? this.codMotivoCancelamento,
      descricaoMotivoCancelamento:
          descricaoMotivoCancelamento ?? this.descricaoMotivoCancelamento,
      dataCancelamento: dataCancelamento ?? this.dataCancelamento,
      horaCancelamento: horaCancelamento ?? this.horaCancelamento,
      codUsuarioCancelamento:
          codUsuarioCancelamento ?? this.codUsuarioCancelamento,
      nomeUsuarioCancelamento:
          nomeUsuarioCancelamento ?? this.nomeUsuarioCancelamento,
      observacaoCancelamento:
          observacaoCancelamento ?? this.observacaoCancelamento,
    );
  }

  factory ExpedicaoCarrinhoPercursoConsultaModel.fromJson(
      Map<String, dynamic> map) {
    return ExpedicaoCarrinhoPercursoConsultaModel(
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
      codUsuarioInicio: map['CodUsuarioInicio'],
      nomeUsuarioInicio: map['NomeUsuarioInicio'],
      dataFinalizacao: AppHelper.tryStringToDateOrNull(map['DataFinalizacao']),
      horaFinalizacao: map['HoraFinalizacao'],
      codSetorEstoque: map['CodSetorEstoque'],
      nomeSetorEstoque: map['NomeSetorEstoque'],
      codCancelamento: map['CodCancelamento'],
      codMotivoCancelamento: map['CodMotivoCancelamento'],
      descricaoMotivoCancelamento: map['DescricaoMotivoCancelamento'],
      dataCancelamento:
          AppHelper.tryStringToDateOrNull(map['DataCancelamento']),
      horaCancelamento: map['HoraCancelamento'],
      codUsuarioCancelamento: map['CodUsuarioCancelamento'],
      nomeUsuarioCancelamento: map['NomeUsuarioCancelamento'],
      observacaoCancelamento: map['ObservacaoCancelamento'],
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
      'DataInicio': dataInicio.toIso8601String(),
      'HoraInicio': horaInicio,
      'CodUsuarioInicio': codUsuarioInicio,
      'NomeUsuarioInicio': nomeUsuarioInicio,
      'DataFinalizacao': dataFinalizacao?.toIso8601String(),
      'HoraFinalizacao': horaFinalizacao,
      'CodSetorEstoque': codSetorEstoque,
      'NomeSetorEstoque': nomeSetorEstoque,
      'CodCancelamento': codCancelamento,
      'CodMotivoCancelamento': codMotivoCancelamento,
      'DescricaoMotivoCancelamento': descricaoMotivoCancelamento,
      'DataCancelamento': dataCancelamento?.toIso8601String(),
      'HoraCancelamento': horaCancelamento,
      'CodUsuarioCancelamento': codUsuarioCancelamento,
      'NomeUsuarioCancelamento': nomeUsuarioCancelamento,
      'ObservacaoCancelamento': observacaoCancelamento,
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoCarrinhoPercursoConsultaModel(
        codEmpresa: $codEmpresa, 
        codCarrinhoPercurso: $codCarrinhoPercurso, 
        item: $item, 
        codPercursoEstagio: $codPercursoEstagio, 
        origem: $origem, 
        codOrigem: $codOrigem, 
        situacao: $situacao, 
        codCarrinho: $codCarrinho, 
        nomeCarrinho: $nomeCarrinho, 
        codigoBarrasCarrinho: $codigoBarrasCarrinho, 
        ativo: $ativo, 
        dataInicio: $dataInicio, 
        horaInicio: $horaInicio, 
        codUsuarioInicio: $codUsuarioInicio, 
        nomeUsuarioInicio: $nomeUsuarioInicio, 
        dataFinalizacao: $dataFinalizacao, 
        horaFinalizacao: $horaFinalizacao, 
        codSetorEstoque: $codSetorEstoque, 
        nomeSetorEstoque: $nomeSetorEstoque, 
        codCancelamento: $codCancelamento, 
        codMotivoCancelamento: $codMotivoCancelamento, 
        descricaoMotivoCancelamento: $descricaoMotivoCancelamento, 
        dataCancelamento: $dataCancelamento, 
        horaCancelamento: $horaCancelamento, 
        codUsuarioCancelamento: $codUsuarioCancelamento, 
        nomeUsuarioCancelamento: $nomeUsuarioCancelamento, 
        observacaoCancelamento: $observacaoCancelamento)
    ''';
  }
}
