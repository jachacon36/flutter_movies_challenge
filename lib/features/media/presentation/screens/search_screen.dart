import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_movies_challenge/core/error/failure.dart';
import 'package:flutter_movies_challenge/core/widgets/empty_view.dart';
import 'package:flutter_movies_challenge/core/widgets/error_view.dart';
import 'package:flutter_movies_challenge/core/widgets/loading_view.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_movies_challenge/features/media/presentation/navigation/media_navigation.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_providers.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/search_notifier.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/search_state.dart';
import 'package:flutter_movies_challenge/features/media/presentation/widgets/paginated_media_grid.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchScreen extends HookConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final notifier = ref.read(searchProvider.notifier);
    final state = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search movies or TV shows',
            border: InputBorder.none,
          ),
          onChanged: notifier.updateQuery,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<MediaType>(
              segments: const [
                ButtonSegment(value: MediaType.movie, label: Text('Movies')),
                ButtonSegment(value: MediaType.tv, label: Text('TV Shows')),
              ],
              selected: {state.valueOrNull?.type ?? MediaType.movie},
              onSelectionChanged: (selection) =>
                  notifier.updateType(selection.first),
            ),
          ),
          Expanded(
            child: state.when(
              data: (data) => _SearchResults(data: data),
              loading: () => const LoadingView(),
              error: (error, stackTrace) => ErrorView(
                message: error is Failure
                    ? error.message
                    : 'Something went wrong.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.data});

  final SearchState data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.query.trim().isEmpty) {
      return const EmptyView(
        message: 'Search for a movie or TV show.',
        icon: Icons.search,
      );
    }
    if (data.items.isEmpty) {
      return const EmptyView(message: 'No results found.');
    }
    return PaginatedMediaGrid(
      items: data.items,
      hasMore: data.hasMore,
      isLoadingMore: data.isLoadingMore,
      onLoadMore: () => ref.read(searchProvider.notifier).loadNextPage(),
      onTapItem: (media) => ref
          .read(navigationServiceProvider)
          .pushNamed(mediaDetailPath(type: media.type, id: media.id)),
    );
  }
}
