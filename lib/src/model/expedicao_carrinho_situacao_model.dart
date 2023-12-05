abstract class ExpedicaoCarrinhoSituacaoModel {
  static const liberado = 'LIBERADO';
  static const emSeparacao = 'EM SEPARACAO';
  static const emConferencia = 'EM CONFERENCIA';
  static const cancelado = 'CANCELADO';
  static const finalizado = 'FINALIZADO';

  static Map<String, String> situacao = {
    liberado: 'Liberado',
    emSeparacao: 'Em Separação',
    emConferencia: 'Em Conferência',
    cancelado: 'Cancelado',
    finalizado: 'Finalizado',
    '': ''
  };
}
