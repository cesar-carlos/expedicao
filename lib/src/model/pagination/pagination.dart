class Pagination {
  final int limit;
  final int offset;
  final int page;

  const Pagination({
    required this.limit,
    required this.offset,
    required this.page,
  });

  static Pagination create({int limit = 50, int offset = 0, int page = 1}) {
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
