abstract class ExpedicaoCarrinhoSituacaoModel {
  static const liberado = 'LIBERADO';
  static const emUso = 'EM USO';
  static const cancelado = 'CANCELADO';
  static const finalizado = 'FINALIZADO';

  static Map<String, String> situacao = {
    liberado: 'Liberado',
    emUso: 'Em Uso',
    cancelado: 'Cancelado',
    finalizado: 'Finalizado',
    '': ''
  };
}
