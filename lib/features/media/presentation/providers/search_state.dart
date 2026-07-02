import 'package:flutter_movies_challenge/features/media/domain/entities/media_summary.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';

class SearchState {
  const SearchState({
    required this.query,
    required this.type,
    required this.items,
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  const SearchState.initial()
    : query = '',
      type = MediaType.movie,
      items = const [],
      page = 1,
      hasMore = false,
      isLoadingMore = false;

  final String query;
  final MediaType type;
  final List<MediaSummary> items;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  SearchState copyWith({
    String? query,
    MediaType? type,
    List<MediaSummary>? items,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return SearchState(
      query: query ?? this.query,
      type: type ?? this.type,
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
