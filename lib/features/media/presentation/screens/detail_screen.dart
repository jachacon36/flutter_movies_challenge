import 'package:flutter/material.dart';
import 'package:flutter_movies_challenge/core/error/failure.dart';
import 'package:flutter_movies_challenge/core/utils/image_url_builder.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_detail.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_detail_key.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_detail_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({required this.mediaKey, super.key});

  final MediaDetailKey mediaKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(mediaDetailProvider(mediaKey));

    return Scaffold(
      body: detail.when(
        data: (media) => _DetailBody(media: media),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            error is Failure ? error.message : 'Something went wrong.',
          ),
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.media});

  final MediaDetail media;

  @override
  Widget build(BuildContext context) {
    final backdropPath = media.backdropPath;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 240,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: backdropPath == null
                ? ColoredBox(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  )
                : Image.network(
                    buildBackdropUrl(backdropPath),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => ColoredBox(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                    ),
                  ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  media.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                _DetailMeta(media: media),
                if (media.genres.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: media.genres
                        .map((genre) => Chip(label: Text(genre)))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 16),
                Text(media.overview),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailMeta extends StatelessWidget {
  const _DetailMeta({required this.media});

  final MediaDetail media;

  @override
  Widget build(BuildContext context) {
    final releaseDate = media.releaseDate;
    final runtime = media.runtime;
    final numberOfSeasons = media.numberOfSeasons;

    return Wrap(
      spacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, size: 16),
            const SizedBox(width: 4),
            Text(media.voteAverage.toStringAsFixed(1)),
          ],
        ),
        if (releaseDate != null) Text(releaseDate),
        if (runtime != null) Text('$runtime min'),
        if (numberOfSeasons != null) Text('$numberOfSeasons seasons'),
      ],
    );
  }
}
