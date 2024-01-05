abstract class ExpedicaoOrigemModel {
  static const String separacao = 'SE';
  static const String conferencia = 'CO';
  static const String expedicao = 'EX';
  static const String carrinhoPercurso = 'CP';
  static const String conferenciaFinal = 'CF';
  static const String vazio = '';

  static String getDescricao(String origem) {
    return ExpedicaoOrigemModel._origem[origem] ?? '';
  }

  static final Map<String?, String> _origem = {
    'SE': 'Separação',
    'CO': 'Conferencia',
    'EX': 'Expedição',
    'CP': 'Carrinho Percurso',
    'CF': 'Conferencia',
    'EM': 'Embalagem',
    '': ''
  };
}
