import 'package:flutter_movies_challenge/features/media/domain/entities/media_summary.dart';

class MediaListState {
  const MediaListState({
    required this.items,
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<MediaSummary> items;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  MediaListState copyWith({
    List<MediaSummary>? items,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return MediaListState(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
