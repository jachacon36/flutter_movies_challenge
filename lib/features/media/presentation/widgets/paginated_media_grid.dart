import 'package:flutter/material.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_summary.dart';
import 'package:flutter_movies_challenge/features/media/presentation/widgets/media_card.dart';

const double _loadMoreThreshold = 200;

class PaginatedMediaGrid extends StatelessWidget {
  const PaginatedMediaGrid({
    required this.items,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.onTapItem,
    super.key,
  });

  final List<MediaSummary> items;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final void Function(MediaSummary media) onTapItem;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        final metrics = notification.metrics;
        if (hasMore &&
            !isLoadingMore &&
            metrics.pixels >= metrics.maxScrollExtent - _loadMoreThreshold) {
          onLoadMore();
        }
        return false;
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final media = items[index];
          return MediaCard(media: media, onTap: () => onTapItem(media));
        },
      ),
    );
  }
}
