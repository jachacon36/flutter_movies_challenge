import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_movies_challenge/core/routing/route_names.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_category.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_providers.dart';
import 'package:flutter_movies_challenge/features/media/presentation/widgets/media_grid.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);
    final selectedType = useState(MediaType.movie);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Movies Challenge'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => ref
                .read(navigationServiceProvider)
                .pushNamed(RouteNames.search),
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Popular'),
            Tab(text: 'Top Rated'),
          ],
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
              selected: {selectedType.value},
              onSelectionChanged: (selection) =>
                  selectedType.value = selection.first,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                MediaGrid(
                  mediaKey: (
                    type: selectedType.value,
                    category: MediaCategory.popular,
                  ),
                ),
                MediaGrid(
                  mediaKey: (
                    type: selectedType.value,
                    category: MediaCategory.topRated,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
