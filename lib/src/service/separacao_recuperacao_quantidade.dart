import 'dart:math' as math;

double quantidadeRecuperacaoPendente({
  required double quantidadeCancelada,
  required double quantidadeDestino,
  required double quantidadePedido,
  required double quantidadeJaSeparada,
}) => math.max(
  0,
  math.min(
    quantidadeCancelada - quantidadeDestino,
    quantidadePedido - quantidadeJaSeparada,
  ),
);
