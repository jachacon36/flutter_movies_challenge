import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_detail.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';

part 'media_detail_model.freezed.dart';

/// TMDB uses different JSON shapes for movies ("title"/"release_date") and
/// TV shows ("name"/"first_air_date"), so there is no single blind `fromJson`
/// here — callers must pick [fromMovieJson] or [fromTvJson] based on the
/// requested [MediaType].
@freezed
class MediaDetailModel with _$MediaDetailModel {
  const MediaDetailModel._();

  const factory MediaDetailModel({
    required int id,
    required MediaType type,
    required String title,
    required String overview,
    String? posterPath,
    String? backdropPath,
    String? releaseDate,
    required double voteAverage,
    required int voteCount,
    required List<String> genres,
    int? runtime,
    int? numberOfSeasons,
    int? numberOfEpisodes,
  }) = _MediaDetailModel;

  factory MediaDetailModel.fromMovieJson(Map<String, dynamic> json) {
    return MediaDetailModel(
      id: json['id'] as int,
      type: MediaType.movie,
      title: json['title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: _emptyToNull(json['release_date'] as String?),
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: json['vote_count'] as int? ?? 0,
      genres: _parseGenres(json['genres']),
      runtime: json['runtime'] as int?,
    );
  }

  factory MediaDetailModel.fromTvJson(Map<String, dynamic> json) {
    return MediaDetailModel(
      id: json['id'] as int,
      type: MediaType.tv,
      title: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: _emptyToNull(json['first_air_date'] as String?),
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: json['vote_count'] as int? ?? 0,
      genres: _parseGenres(json['genres']),
      numberOfSeasons: json['number_of_seasons'] as int?,
      numberOfEpisodes: json['number_of_episodes'] as int?,
    );
  }

  MediaDetail toEntity() => MediaDetail(
    id: id,
    type: type,
    title: title,
    overview: overview,
    posterPath: posterPath,
    backdropPath: backdropPath,
    releaseDate: releaseDate,
    voteAverage: voteAverage,
    voteCount: voteCount,
    genres: genres,
    runtime: runtime,
    numberOfSeasons: numberOfSeasons,
    numberOfEpisodes: numberOfEpisodes,
  );
}

String? _emptyToNull(String? value) =>
    (value == null || value.isEmpty) ? null : value;

List<String> _parseGenres(Object? genres) {
  if (genres is! List) return const [];
  return genres
      .whereType<Map<String, dynamic>>()
      .map((genre) => genre['name'] as String? ?? '')
      .where((name) => name.isNotEmpty)
      .toList();
}
