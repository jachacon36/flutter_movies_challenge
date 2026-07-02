import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';

class MediaDetail {
  const MediaDetail({
    required this.id,
    required this.type,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genres,
    this.runtime,
    this.numberOfSeasons,
    this.numberOfEpisodes,
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
  final List<String> genres;

  /// Movie runtime in minutes. Null for TV shows.
  final int? runtime;

  /// Null for movies.
  final int? numberOfSeasons;

  /// Null for movies.
  final int? numberOfEpisodes;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaDetail &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          title == other.title &&
          overview == other.overview &&
          posterPath == other.posterPath &&
          backdropPath == other.backdropPath &&
          releaseDate == other.releaseDate &&
          voteAverage == other.voteAverage &&
          voteCount == other.voteCount &&
          _listEquals(genres, other.genres) &&
          runtime == other.runtime &&
          numberOfSeasons == other.numberOfSeasons &&
          numberOfEpisodes == other.numberOfEpisodes;

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
    Object.hashAll(genres),
    runtime,
    numberOfSeasons,
    numberOfEpisodes,
  );
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
