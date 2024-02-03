class GlobalSequenciaRegistroModel {
  String nome;
  int valor;

  GlobalSequenciaRegistroModel({
    required this.nome,
    required this.valor,
  });

  factory GlobalSequenciaRegistroModel.fromJson(Map<String, dynamic> json) {
    return GlobalSequenciaRegistroModel(
      nome: json['Nome'],
      valor: json['Valor'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'Nome': nome, 'Valor': valor};
  }

  @override
  String toString() => 'SequenciaRegistroModel(nome: $nome, valor: $valor)';
}
