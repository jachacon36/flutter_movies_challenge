import 'package:flutter/material.dart';
import 'package:flutter_movies_challenge/core/error/failure.dart';
import 'package:flutter_movies_challenge/core/widgets/empty_view.dart';
import 'package:flutter_movies_challenge/core/widgets/error_view.dart';
import 'package:flutter_movies_challenge/core/widgets/loading_view.dart';
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
      data: (data) => data.items.isEmpty
          ? const EmptyView(message: 'No results found.')
          : PaginatedMediaGrid(
              items: data.items,
              hasMore: data.hasMore,
              isLoadingMore: data.isLoadingMore,
              onLoadMore: () =>
                  ref.read(mediaListProvider(mediaKey).notifier).loadNextPage(),
              onTapItem: (media) => ref
                  .read(navigationServiceProvider)
                  .pushNamed(mediaDetailPath(type: media.type, id: media.id)),
            ),
      loading: () => const LoadingView(),
      error: (error, stackTrace) => ErrorView(
        message: error is Failure ? error.message : 'Something went wrong.',
        onRetry: () => ref.invalidate(mediaListProvider(mediaKey)),
      ),
    );
  }
}
