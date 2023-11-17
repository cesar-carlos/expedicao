import 'package:app_expedicao/src/app/app_helper.dart';

class ProcessoExecutavelModel {
  int codProcessoExecutavel;
  int codEmpresa;
  int codFilial;
  String status;
  String origem;
  int codOrigem;
  String itemOrigem;
  DateTime dataAbertura;
  int codUsuario;
  String nomeUsuario;
  String codContaFinanceira;
  int codPeriodoCaixa;
  String statusPeriodoCaixa;
  String nomeComputador;
  String usuarioWindows;
  String bancoDados;

  ProcessoExecutavelModel({
    required this.codProcessoExecutavel,
    required this.codEmpresa,
    required this.codFilial,
    required this.status,
    required this.origem,
    required this.codOrigem,
    required this.itemOrigem,
    required this.dataAbertura,
    required this.codUsuario,
    required this.nomeUsuario,
    required this.codContaFinanceira,
    required this.codPeriodoCaixa,
    required this.statusPeriodoCaixa,
    required this.nomeComputador,
    required this.usuarioWindows,
    required this.bancoDados,
  });

  ProcessoExecutavelModel copyWith({
    int? codProcessoExecutavel,
    int? codEmpresa,
    int? codFilial,
    String? status,
    String? origem,
    int? codOrigem,
    String? itemOrigem,
    DateTime? dataAbertura,
    int? codUsuario,
    String? nomeUsuario,
    String? codContaFinanceira,
    int? codPeriodoCaixa,
    String? statusPeriodoCaixa,
    String? nomeComputador,
    String? usuarioWindows,
    String? bancoDados,
  }) {
    return ProcessoExecutavelModel(
      codProcessoExecutavel:
          codProcessoExecutavel ?? this.codProcessoExecutavel,
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codFilial: codFilial ?? this.codFilial,
      status: status ?? this.status,
      origem: origem ?? this.origem,
      codOrigem: codOrigem ?? this.codOrigem,
      itemOrigem: itemOrigem ?? this.itemOrigem,
      dataAbertura: dataAbertura ?? this.dataAbertura,
      codUsuario: codUsuario ?? this.codUsuario,
      nomeUsuario: nomeUsuario ?? this.nomeUsuario,
      codContaFinanceira: codContaFinanceira ?? this.codContaFinanceira,
      codPeriodoCaixa: codPeriodoCaixa ?? this.codPeriodoCaixa,
      statusPeriodoCaixa: statusPeriodoCaixa ?? this.statusPeriodoCaixa,
      nomeComputador: nomeComputador ?? this.nomeComputador,
      usuarioWindows: usuarioWindows ?? this.usuarioWindows,
      bancoDados: bancoDados ?? this.bancoDados,
    );
  }

  factory ProcessoExecutavelModel.empty() {
    return ProcessoExecutavelModel(
      codProcessoExecutavel: 0,
      codEmpresa: 0,
      codFilial: 0,
      status: '',
      origem: '',
      codOrigem: 0,
      itemOrigem: '',
      dataAbertura: DateTime.now(),
      codUsuario: 0,
      nomeUsuario: '',
      codContaFinanceira: '',
      codPeriodoCaixa: 0,
      statusPeriodoCaixa: '',
      nomeComputador: '',
      usuarioWindows: '',
      bancoDados: '',
    );
  }

  update(ProcessoExecutavelModel input) {
    codProcessoExecutavel = input.codProcessoExecutavel;
    codEmpresa = input.codEmpresa;
    codFilial = input.codFilial;
    status = input.status;
    origem = input.origem;
    codOrigem = input.codOrigem;
    itemOrigem = input.itemOrigem;
    dataAbertura = input.dataAbertura;
    codUsuario = input.codUsuario;
    nomeUsuario = input.nomeUsuario;
    codContaFinanceira = input.codContaFinanceira;
    codPeriodoCaixa = input.codPeriodoCaixa;
    statusPeriodoCaixa = input.statusPeriodoCaixa;
    nomeComputador = input.nomeComputador;
    usuarioWindows = input.usuarioWindows;
    bancoDados = input.bancoDados;
  }

  factory ProcessoExecutavelModel.fromJson(Map map) {
    return ProcessoExecutavelModel(
      codProcessoExecutavel: int.parse(map['CodProcessoExecutavel']),
      codEmpresa: map['CodEmpresa'],
      codFilial: map['CodFilial'],
      status: map['Status'],
      origem: map['Origem'],
      codOrigem: map['CodOrigem'],
      itemOrigem: map['ItemOrigem'],
      dataAbertura: AppHelper.tryStringToDate(map['DataAbertura']),
      codUsuario: map['CodUsuario'],
      nomeUsuario: map['NomeUsuario'],
      codContaFinanceira: map['CodContaFinanceira'],
      codPeriodoCaixa: map['CodPeriodoCaixa'],
      statusPeriodoCaixa: map['StatusPeriodoCaixa'],
      nomeComputador: map['NomeComputador'],
      usuarioWindows: map['UsuarioWindows'],
      bancoDados: map['BancoDados'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodProcessoExecutavel': codProcessoExecutavel,
      'CodEmpresa': codEmpresa,
      'CodFilial': codFilial,
      'Status': status,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'ItemOrigem': itemOrigem,
      'DataAbertura': dataAbertura.toIso8601String(),
      'CodUsuario': codUsuario,
      'NomeUsuario': nomeUsuario,
      'CodContaFinanceira': codContaFinanceira,
      'CodPeriodoCaixa': codPeriodoCaixa,
      'StatusPeriodoCaixa': statusPeriodoCaixa,
      'NomeComputador': nomeComputador,
      'UsuarioWindows': usuarioWindows,
      'BancoDados': bancoDados,
    };
  }

  @override
  String toString() {
    return 'ProcessoExecutavelModel(codProcessoExecutavel: $codProcessoExecutavel, codEmpresa: $codEmpresa, codFilial: $codFilial, status: $status, origem: $origem, codOrigem: $codOrigem, itemOrigem: $itemOrigem, dataAbertura: $dataAbertura, codUsuario: $codUsuario, nomeUsuario: $nomeUsuario, codContaFinanceira: $codContaFinanceira, codPeriodoCaixa: $codPeriodoCaixa, statusPeriodoCaixa: $statusPeriodoCaixa, nomeComputador: $nomeComputador, usuarioWindows: $usuarioWindows, bancoDados: $bancoDados)';
  }
}
