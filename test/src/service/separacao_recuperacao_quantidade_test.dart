import 'package:flutter_test/flutter_test.dart';
import 'package:app_expedicao/src/service/separacao_recuperacao_quantidade.dart';

void main() {
  test(
    'repetição após gravação confirmada não duplica apesar de haver saldo',
    () {
      var destino = 0.0;
      var documento = 3.0;
      for (var tentativa = 0; tentativa < 3; tentativa++) {
        final copia = quantidadeRecuperacaoPendente(
          quantidadeCancelada: 5,
          quantidadeDestino: destino,
          quantidadePedido: 20,
          quantidadeJaSeparada: documento,
        );
        destino += copia;
        documento += copia;
      }
      expect(destino, 5);
      expect(documento, 8);
    },
  );
  test('retomada com parte gravada completa apenas a diferença', () {
    expect(
      quantidadeRecuperacaoPendente(
        quantidadeCancelada: 8,
        quantidadeDestino: 3,
        quantidadePedido: 30,
        quantidadeJaSeparada: 10,
      ),
      5,
    );
  });
  test('outros carrinhos podem reduzir o saldo disponível', () {
    expect(
      quantidadeRecuperacaoPendente(
        quantidadeCancelada: 8,
        quantidadeDestino: 3,
        quantidadePedido: 20,
        quantidadeJaSeparada: 18,
      ),
      2,
    );
  });
  test('destino preenchido manualmente e pedido excedido não geram cópia', () {
    expect(
      quantidadeRecuperacaoPendente(
        quantidadeCancelada: 8,
        quantidadeDestino: 10,
        quantidadePedido: 30,
        quantidadeJaSeparada: 10,
      ),
      0,
    );
    expect(
      quantidadeRecuperacaoPendente(
        quantidadeCancelada: 8,
        quantidadeDestino: 0,
        quantidadePedido: 20,
        quantidadeJaSeparada: 21,
      ),
      0,
    );
  });
}
