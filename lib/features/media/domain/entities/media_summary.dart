import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';

class MediaSummary {
  const MediaSummary({
    required this.id,
    required this.type,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
  });

  final int id;
  final MediaType type;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double voteAverage;
  final int voteCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaSummary &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          title == other.title &&
          overview == other.overview &&
          posterPath == other.posterPath &&
          backdropPath == other.backdropPath &&
          releaseDate == other.releaseDate &&
          voteAverage == other.voteAverage &&
          voteCount == other.voteCount;

  @override
  int get hashCode => Object.hash(
    id,
    type,
    title,
    overview,
    posterPath,
    backdropPath,
    releaseDate,
    voteAverage,
    voteCount,
  );
}
