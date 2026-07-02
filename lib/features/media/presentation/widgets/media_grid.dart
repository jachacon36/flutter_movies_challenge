import 'package:flutter/material.dart';
import 'package:flutter_movies_challenge/core/error/failure.dart';
import 'package:flutter_movies_challenge/features/media/presentation/navigation/media_navigation.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_list_key.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_list_notifier.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_providers.dart';
import 'package:flutter_movies_challenge/features/media/presentation/widgets/paginated_media_grid.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MediaGrid extends ConsumerWidget {
  const MediaGrid({required this.mediaKey, super.key});

  final MediaListKey mediaKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mediaListProvider(mediaKey));

    return state.when(
      data: (data) => PaginatedMediaGrid(
        items: data.items,
        hasMore: data.hasMore,
        isLoadingMore: data.isLoadingMore,
        onLoadMore: () =>
            ref.read(mediaListProvider(mediaKey).notifier).loadNextPage(),
        onTapItem: (media) => ref
            .read(navigationServiceProvider)
            .pushNamed(mediaDetailPath(type: media.type, id: media.id)),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text(error is Failure ? error.message : 'Something went wrong.'),
      ),
    );
  }
}
