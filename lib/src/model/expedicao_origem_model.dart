abstract class ExpedicaoOrigemModel {
  static const String separando = 'SE';
  static const String conferencia = 'CO';
  static const String expedicao = 'EX';
  static const String carrinhoPercurso = 'CP';
  static const String vazio = '';

  static String getDescricao(String origem) {
    return ExpedicaoOrigemModel._origem[origem] ?? '';
  }

  static final Map<String?, String> _origem = {
    'SE': 'Separando',
    'CO': 'Conferencia',
    'EX': 'Expedição',
    'CP': 'Carrinho Percurso',
    '': ''
  };
}
