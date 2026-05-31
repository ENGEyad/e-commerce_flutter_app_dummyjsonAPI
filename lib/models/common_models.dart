// lib/models/common_models.dart
class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int skip;
  final int limit;

  PaginatedResponse({
    required this.items,
    required this.total,
    required this.skip,
    required this.limit,
  });
}