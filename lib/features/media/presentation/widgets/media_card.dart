import 'package:flutter/material.dart';
import 'package:flutter_movies_challenge/core/utils/image_url_builder.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_summary.dart';

class MediaCard extends StatelessWidget {
  const MediaCard({required this.media, this.onTap, super.key});

  final MediaSummary media;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final posterPath = media.posterPath;
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: posterPath == null
                  ? const _PosterPlaceholder(icon: Icons.movie_outlined)
                  : Image.network(
                      buildPosterUrl(posterPath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const _PosterPlaceholder(
                            icon: Icons.broken_image_outlined,
                          ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Text(
                media.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterPlaceholder extends StatelessWidget {
  const _PosterPlaceholder({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(icon),
    );
  }
}
