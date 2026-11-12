class Pagination {
  /// Teto técnico do LIMIT no SQL Server. Um LIMIT explícito do cliente
  /// não é cortado nos 1500 do servidor.
  static const int sqlIntMax = 2147483647;

  /// Página do coletor ao buscar a lista inteira em vários pedidos.
  /// 500 equilibra payload do socket e número de idas ao servidor
  /// (o padrão do servidor, 1500, trava a fila num único JSON).
  static const int fetchPageSize = 500;

  /// 200 × 500 = 100_000 linhas. Acima disso a consulta está errada.
  static const int maxFetchPages = 200;

  final int limit;
  final int offset;
  final int page;

  const Pagination._({
    required this.limit,
    required this.offset,
    required this.page,
  });

  factory Pagination({required int limit, int? offset, required int page}) {
    final normalizedLimit = limit < 1 ? 1 : limit;
    final normalizedPage = page < 1 ? 1 : page;
    final resolvedOffset = offset ?? ((normalizedPage - 1) * normalizedLimit);
    final normalizedOffset = resolvedOffset < 0 ? 0 : resolvedOffset;

    return Pagination._(
      limit: normalizedLimit,
      offset: normalizedOffset,
      page: normalizedPage,
    );
  }

  static Pagination create({int limit = 50, int? offset, int page = 1}) {
    return Pagination(limit: limit, offset: offset, page: page);
  }

  String toQueryString() {
    return 'LIMIT=$limit&OFFSET=$offset&PAGE=$page';
  }

  @override
  String toString() {
    return 'Pagination(limit: $limit, offset: $offset, page: $page)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pagination &&
        other.limit == limit &&
        other.offset == offset &&
        other.page == page;
  }

  @override
  int get hashCode => Object.hash(limit, offset, page);
}
