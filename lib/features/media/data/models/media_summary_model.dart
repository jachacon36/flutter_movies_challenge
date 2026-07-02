import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_summary.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';

part 'media_summary_model.freezed.dart';

/// TMDB uses different JSON shapes for movies ("title"/"release_date") and
/// TV shows ("name"/"first_air_date"), so there is no single blind `fromJson`
/// here — callers must pick [fromMovieJson] or [fromTvJson] based on the
/// requested [MediaType].
@freezed
class MediaSummaryModel with _$MediaSummaryModel {
  const MediaSummaryModel._();

  const factory MediaSummaryModel({
    required int id,
    required MediaType type,
    required String title,
    required String overview,
    String? posterPath,
    String? backdropPath,
    String? releaseDate,
    required double voteAverage,
    required int voteCount,
  }) = _MediaSummaryModel;

  factory MediaSummaryModel.fromMovieJson(Map<String, dynamic> json) {
    return MediaSummaryModel(
      id: json['id'] as int,
      type: MediaType.movie,
      title: json['title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: _emptyToNull(json['release_date'] as String?),
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: json['vote_count'] as int? ?? 0,
    );
  }

  factory MediaSummaryModel.fromTvJson(Map<String, dynamic> json) {
    return MediaSummaryModel(
      id: json['id'] as int,
      type: MediaType.tv,
      title: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: _emptyToNull(json['first_air_date'] as String?),
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: json['vote_count'] as int? ?? 0,
    );
  }

  MediaSummary toEntity() => MediaSummary(
    id: id,
    type: type,
    title: title,
    overview: overview,
    posterPath: posterPath,
    backdropPath: backdropPath,
    releaseDate: releaseDate,
    voteAverage: voteAverage,
    voteCount: voteCount,
  );
}

String? _emptyToNull(String? value) =>
    (value == null || value.isEmpty) ? null : value;
