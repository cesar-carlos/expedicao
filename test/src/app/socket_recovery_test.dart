import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/socket_recovery.dart';

void main() {
  test(
    'reconexão compartilha uma recarga e exige revisão antes de gravar',
    () async {
      final recovery = SocketRecovery(canRead: () => true);
      final loaded = Completer<void>();
      var reads = 0;
      recovery.register('documento', () async {
        reads++;
        await loaded.future;
      });
      recovery.invalidate();
      final first = recovery.refresh();
      final second = recovery.refresh();
      expect(identical(first, second), isTrue);
      loaded.complete();
      await first;
      expect(reads, 1);
      await expectLater(recovery.beforeMutation(), throwsA(isA<AppError>()));
      await recovery.beforeMutation();
      expect(reads, 1);
    },
  );

  test(
    'resposta perdida recarrega estado parcial e não reaproveita tentativa',
    () async {
      final recovery = SocketRecovery(canRead: () => true);
      final persisted = [1, 2]; // Dois inserts de um lote foram gravados.
      final grid = [1];
      recovery.register('carrinho', () async {
        grid
          ..clear()
          ..addAll(persisted);
      });
      recovery.mutationUncertain();
      await expectLater(recovery.beforeMutation(), throwsA(isA<AppError>()));
      expect(grid, [1, 2]);
      expect(recovery.needsRefresh, isFalse);
      await recovery.beforeMutation();
      expect(grid, [1, 2]);
    },
  );

  test(
    'falha de leitura mantém bloqueio e permite nova consulta por ação',
    () async {
      var fail = true;
      final recovery = SocketRecovery(canRead: () => true);
      recovery.register('doc', () async {
        if (fail) throw AppError('SQL-CONN');
      });
      recovery.mutationUncertain();
      await expectLater(recovery.beforeMutation(), throwsA(isA<AppError>()));
      expect(recovery.needsRefresh, isTrue);
      fail = false;
      await expectLater(recovery.beforeMutation(), throwsA(isA<AppError>()));
      await recovery.beforeMutation();
    },
  );

  test('emergência impede consultas e mantém pendência', () async {
    var paused = true;
    var reads = 0;
    final recovery = SocketRecovery(canRead: () => !paused);
    recovery.register('doc', () async {
      reads++;
    });
    recovery.mutationUncertain();
    await expectLater(recovery.refresh(), throwsA(isA<AppError>()));
    expect(reads, 0);
    paused = false;
    await recovery.refresh();
    expect(reads, 1);
  });

  test('mudança durante snapshot causa releitura limitada', () async {
    final recovery = SocketRecovery(canRead: () => true);
    var reads = 0;
    recovery.register('doc', () async {
      reads++;
      if (reads == 1) recovery.receivedChange();
    });
    recovery.invalidate();
    await recovery.refresh();
    expect(reads, 2);
    recovery.register('doc', () async {
      reads++;
      recovery.receivedChange();
    });
    recovery.invalidate();
    await expectLater(recovery.refresh(), throwsA(isA<AppError>()));
    expect(reads, 5);
    expect(recovery.needsRefresh, isTrue);
  });

  test('fechar tela durante recarga não chama callback removido', () async {
    final recovery = SocketRecovery(canRead: () => true);
    var cartReads = 0;
    recovery.register('doc', () async {
      recovery.unregister('cart');
    });
    recovery.register('cart', () async {
      cartReads++;
    });
    recovery.invalidate();
    // Remove somente uma vez, sem invalidar o snapshot seguinte.
    var removed = false;
    recovery.register('doc', () async {
      if (!removed) {
        removed = true;
        recovery.unregister('cart');
      }
    });
    await recovery.refresh();
    expect(cartReads, 0);
  });

  test('sem documento aberto não libera mutação incerta', () async {
    final recovery = SocketRecovery(canRead: () => true)..mutationUncertain();
    await expectLater(recovery.beforeMutation(), throwsA(isA<AppError>()));
    expect(recovery.needsRefresh, isTrue);
  });
}
