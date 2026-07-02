import 'package:flutter/material.dart';
import 'package:flutter_movies_challenge/core/error/failure.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_list_key.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_list_notifier.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_list_state.dart';
import 'package:flutter_movies_challenge/features/media/presentation/widgets/media_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const double _loadMoreThreshold = 200;

class MediaGrid extends ConsumerWidget {
  const MediaGrid({required this.mediaKey, super.key});

  final MediaListKey mediaKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mediaListProvider(mediaKey));

    return state.when(
      data: (data) => _MediaGridView(mediaKey: mediaKey, data: data),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text(error is Failure ? error.message : 'Something went wrong.'),
      ),
    );
  }
}

class _MediaGridView extends ConsumerWidget {
  const _MediaGridView({required this.mediaKey, required this.data});

  final MediaListKey mediaKey;
  final MediaListState data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        final metrics = notification.metrics;
        if (data.hasMore &&
            !data.isLoadingMore &&
            metrics.pixels >= metrics.maxScrollExtent - _loadMoreThreshold) {
          ref.read(mediaListProvider(mediaKey).notifier).loadNextPage();
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
        itemCount: data.items.length,
        itemBuilder: (context, index) => MediaCard(media: data.items[index]),
      ),
    );
  }
}
