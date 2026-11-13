class AppError implements Exception {
  final String message;
  final int? code;
  final String? contractCode;
  final String? location;
  final String? details;

  AppError(
    this.message, {
    this.code,
    this.contractCode,
    this.location,
    this.details,
  });

  factory AppError.fromSocket(
    Object? error, {
    int? code,
    String? contractCode,
    String? location,
    String? details,
  }) {
    return AppError(
      socketMessage(error),
      code: code,
      contractCode: contractCode ?? contractCodeOf(error),
      location: location,
      details: details,
    );
  }

  factory AppError.fromResponse(
    Object? response, {
    int? code,
    String? location,
    String? details,
  }) {
    if (response is AppError) {
      return response;
    }

    return AppError.fromSocket(
      response,
      code: code,
      location: location,
      details: details,
    );
  }

  factory AppError.fromUnknown(
    Object? error, {
    int? code,
    String? location,
    String? details,
  }) {
    if (error is AppError) {
      return error;
    }

    return AppError.fromSocket(
      error,
      code: code,
      location: location,
      details: details,
    );
  }

  static final _identifierPattern = RegExp(
    r'^\[(500\d{2}|SQL-[A-Z0-9]+|INVALID_[A-Z0-9_]+|INTERNAL_ERROR|UNAUTHORIZED|NOT_FOUND)\]\s*',
  );

  static String display(Object? error) {
    return AppError.fromUnknown(error).userMessage;
  }

  String? get identifier {
    final match = _identifierPattern.firstMatch(message.trim());
    return match?.group(1);
  }

  /// Lock timeout (`SET LOCK_TIMEOUT`). Mostrar e deixar o usuário tentar de novo.
  bool get isRetryableLock => identifier == 'SQL-1222';

  /// Timeout 30 s / falha de conexão. Não relançar a mesma consulta em loop.
  bool get isConnectionFailure => identifier == 'SQL-CONN';

  String get userMessage {
    var text = message.trim();
    text = text.replaceFirst(_identifierPattern, '').trim();
    text = _humanizeTechnical(text);
    if (text.isEmpty) {
      return 'Não foi possível concluir a operação.';
    }
    return text;
  }

  String get title {
    final id = identifier;
    if (id != null) {
      if (id.startsWith('500')) return 'Operação não permitida';
      if (id == 'SQL-CONN') return 'Falha de conexão';
      if (id == 'SQL-1222') return 'Registro em uso';
      if (id.startsWith('SQL-')) return 'Falha no banco de dados';
      if (id == 'INVALID_PAYLOAD') return 'Dados inválidos';
      if (id == 'UNAUTHORIZED') return 'Sem permissão';
      if (id == 'NOT_FOUND') return 'Registro não encontrado';
      if (id == 'INTERNAL_ERROR') return 'Erro interno';
    }

    final user = userMessage;
    if (user.length <= 72 && !user.contains('\n')) {
      return user;
    }
    return 'Não foi possível concluir';
  }

  String get userDetail {
    final user = userMessage;
    final id = identifier;
    final extra = details?.trim();
    final parts = <String>[];

    if (extra != null && extra.isNotEmpty && extra != user) {
      if (user != title) {
        parts.add(user);
      }
      parts.add(extra);
    } else if (user != title) {
      parts.add(user);
    } else {
      parts.add(user);
    }

    if (id != null) {
      parts.add('Código $id');
    }

    return parts.join('\n\n');
  }

  static String? contractCodeOf(Object? error) {
    if (error is AppError) {
      return error.contractCode;
    }

    if (error is Map) {
      final raw = error['Code'] ?? error['code'];
      if (raw != null) {
        return raw.toString();
      }
    }

    return null;
  }

  static String socketMessage(Object? error) {
    if (error == null) {
      return 'Não foi possível concluir a operação.';
    }

    if (error is AppError) {
      return error.message;
    }

    if (error is List) {
      final parts = error
          .map(socketMessage)
          .map((text) => text.trim())
          .where((text) => text.isNotEmpty)
          .toList();
      if (parts.isNotEmpty) {
        return parts.join('\n');
      }
    }

    if (error is Map) {
      final nested = error['Error'] ?? error['message'] ?? error['Message'];
      if (nested != null) {
        return socketMessage(nested);
      }
    }

    final text = error.toString().trim();
    return _unwrapDartPrefixes(text);
  }

  static String _unwrapDartPrefixes(String text) {
    var current = text;
    const prefixes = [
      'Exception: ',
      'Error: ',
      'AppError: ',
    ];

    var changed = true;
    while (changed) {
      changed = false;
      for (final prefix in prefixes) {
        if (current.startsWith(prefix)) {
          current = current.substring(prefix.length).trim();
          changed = true;
        }
      }
    }

    if (current.startsWith('[') &&
        current.endsWith(']') &&
        !current.startsWith('[500') &&
        !current.startsWith('[SQL-') &&
        !current.startsWith('[INVALID_') &&
        !current.startsWith('[INTERNAL_') &&
        !current.startsWith('[UNAUTHORIZED') &&
        !current.startsWith('[NOT_FOUND')) {
      final inner = current.substring(1, current.length - 1).trim();
      if (inner.isNotEmpty && !inner.contains(',')) {
        return inner;
      }
    }

    return current.isEmpty
        ? 'Não foi possível concluir a operação.'
        : current;
  }

  static String _humanizeTechnical(String text) {
    final lower = text.toLowerCase();
    const connectionHints = [
      'dioexception',
      'socketexception',
      'handshakeexception',
      'timeoutexception',
      'connection refused',
      'connection reset',
      'failed host lookup',
      'network is unreachable',
      'timed out',
      'timeout',
      'os error',
      'errno =',
    ];

    if (connectionHints.any(lower.contains)) {
      return 'Não foi possível conectar ao servidor. Verifique a rede e o endereço da API.';
    }

    if (lower.contains('instance of ') ||
        lower.startsWith('#<') ||
        lower.contains('stack overflow') ||
        lower.contains('null check operator')) {
      return 'Não foi possível concluir a operação.';
    }

    return text;
  }

  @override
  String toString() => message;
}
