class PaginatedResult<T> {
  const PaginatedResult({
    required this.items,
    required this.page,
    required this.totalPages,
    required this.totalResults,
  });

  final List<T> items;
  final int page;
  final int totalPages;
  final int totalResults;

  bool get hasMore => page < totalPages;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginatedResult<T> &&
          runtimeType == other.runtimeType &&
          _listEquals(items, other.items) &&
          page == other.page &&
          totalPages == other.totalPages &&
          totalResults == other.totalResults;

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(items), page, totalPages, totalResults);
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
