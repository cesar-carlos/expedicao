import 'dart:async';

import 'package:app_expedicao/src/app/app_error.dart';

class SocketRecovery {
  final bool Function() canRead;
  final Map<Object, Future<void> Function()> _readers = {};
  final Map<Object, Future<void> Function()> _validators = {};
  Future<void>? _refreshing;
  int _revision = 0;
  bool _dirty = false;
  bool _reviewRequired = false;

  SocketRecovery({required this.canRead});

  bool get needsRefresh => _dirty;
  bool get isRefreshing => _refreshing != null;
  bool get blocksMutation => _dirty || isRefreshing || _reviewRequired;

  void register(Object owner, Future<void> Function() reload) {
    _readers[owner] = reload;
    if (isRefreshing) invalidate();
  }

  void unregister(Object owner) {
    _readers.remove(owner);
    _validators.remove(owner);
    if (isRefreshing) invalidate();
  }

  void registerValidator(Object owner, Future<void> Function() validate) {
    _validators[owner] = validate;
    if (isRefreshing) invalidate();
  }

  void invalidate() {
    _revision++;
    _dirty = true;
    _reviewRequired = true;
  }

  void mutationUncertain() {
    _reviewRequired = true;
    invalidate();
  }

  void receivedChange() {
    if (isRefreshing) invalidate();
  }

  Future<void> refresh() {
    if (!_dirty) return Future.value();
    return _refreshing ??= Future<void>.microtask(_reload)
        .whenComplete(() => _refreshing = null);
  }

  Future<void> _reload() async {
    // Uma nova leitura só é tentada se houve mudança durante o snapshot.
    for (var attempt = 0; attempt < 3; attempt++) {
      if (!canRead()) {
        throw AppError('Reconecte ao servidor para atualizar os dados.');
      }
      if (_readers.isEmpty) {
        throw AppError(
          'Abra o documento para conferir o estado gravado antes de continuar.',
        );
      }
      final revision = _revision;
      for (final entry in Map.of(_readers).entries) {
        if (_readers[entry.key] != entry.value) continue;
        await entry.value();
      }
      if (revision != _revision) continue;
      // Primeiro atualiza todas as telas, depois decide se pode liberar a ação.
      for (final entry in Map.of(_validators).entries) {
        if (_validators[entry.key] != entry.value) continue;
        await entry.value();
      }
      if (!canRead()) {
        throw AppError('A conexão caiu durante a atualização dos dados.');
      }
      if (revision == _revision) {
        _dirty = false;
        return;
      }
    }
    throw AppError('Os dados mudaram durante a atualização. Tente novamente.');
  }

  Future<void> beforeMutation() async {
    final stale = blocksMutation;
    if (!stale) return;
    await refresh();
    _reviewRequired = false;
    // Nunca aproveitar um payload calculado antes da releitura das grades.
    throw AppError(
      'O estado gravado foi consultado e as grades foram atualizadas. '
      'Confira os itens e a situação antes de iniciar uma nova ação. '
      'Esta tentativa não foi enviada.',
    );
  }
}
