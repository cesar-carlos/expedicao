abstract class ExpedicaoCarrinhoSituacaoModel {
  static const liberado = 'LIBERADO';
  static const emSeparacao = 'EM SEPARACAO';
  static const separando = 'SEPARANDO';
  static const separado = 'SEPARADO';
  static const emConferencia = 'EM CONFERENCIA';
  static const conferindo = 'CONFERINDO';
  static const conferido = 'CONFERIDO';
  static const cancelado = 'CANCELADO';
  static const finalizado = 'FINALIZADO';

  static Map<String, String> situacao = {
    liberado: 'Liberado',
    emSeparacao: 'Em Separação',
    separando: 'Separando',
    separado: 'Separado',
    emConferencia: 'Em Conferência',
    conferindo: 'Conferindo',
    conferido: 'Conferido',
    cancelado: 'Cancelado',
    finalizado: 'Finalizado',
    '': ''
  };
}
