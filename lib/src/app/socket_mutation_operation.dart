import 'dart:async';

import 'app_error.dart';
import 'socket_recovery.dart';

class SocketMutationOperation {
  final SocketRecovery recovery;
  final Object _zoneKey = Object();
  _MutationProgress? _active;

  SocketMutationOperation(this.recovery);

  void checkAccess() {
    if (_active != null && Zone.current[_zoneKey] != _active) {
      throw AppError('Aguarde a operação de gravação em andamento.');
    }
  }

  void recorded() {
    final progress = Zone.current[_zoneKey] as _MutationProgress?;
    if (progress != null) progress.hasWrites = true;
  }

  Future<T> run<T>(Future<T> Function() action) async {
    checkAccess();
    final nested = Zone.current[_zoneKey] as _MutationProgress?;
    final progress = nested ?? _MutationProgress();
    if (nested == null) _active = progress;
    try {
      if (nested == null) await recovery.beforeMutation();
      return await runZoned(action, zoneValues: {_zoneKey: progress});
    } catch (error) {
      if (progress.hasWrites) {
        recovery.mutationUncertain();
        final cause = AppError.fromUnknown(error);
        throw AppError(
          'A operação foi interrompida após gravações confirmadas. '
          'O app consultará o estado gravado antes de uma nova ação.',
          contractCode: cause.contractCode,
          details: AppError.display(cause),
        );
      }
      rethrow;
    } finally {
      if (nested == null) _active = null;
    }
  }
}

class _MutationProgress {
  bool hasWrites = false;
}
