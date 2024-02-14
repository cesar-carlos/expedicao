import 'package:get/get.dart';

class ExpedicaoSituacaoListen {
  final int codEmpresa;
  final String origem;
  final int codOrigem;
  final Rx<String> _situacao = ''.obs;

  ExpedicaoSituacaoListen({
    required this.codEmpresa,
    required this.origem,
    required this.codOrigem,
    required String situacao,
  }) {
    _situacao.value = situacao;
  }
}
