import 'package:flutter_movies_challenge/features/media/data/models/media_summary_model.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/fixture_reader.dart';

void main() {
  group('MediaSummaryModel', () {
    test('fromMovieJson parses a real TMDB movie list item', () {
      final page = loadFixture('movie_popular_page1.json');
      final json = (page['results'] as List).first as Map<String, dynamic>;

      final model = MediaSummaryModel.fromMovieJson(json);

      expect(model.id, json['id']);
      expect(model.type, MediaType.movie);
      expect(model.title, json['title']);
      expect(model.overview, json['overview']);
      expect(model.posterPath, json['poster_path']);
      expect(model.backdropPath, json['backdrop_path']);
      expect(model.releaseDate, json['release_date']);
      expect(model.voteAverage, (json['vote_average'] as num).toDouble());
      expect(model.voteCount, json['vote_count']);
    });

    test('fromTvJson parses a real TMDB tv list item', () {
      final page = loadFixture('tv_popular_page1.json');
      final json = (page['results'] as List).first as Map<String, dynamic>;

      final model = MediaSummaryModel.fromTvJson(json);

      expect(model.id, json['id']);
      expect(model.type, MediaType.tv);
      expect(model.title, json['name']);
      expect(model.releaseDate, json['first_air_date']);
    });

    test('normalizes an empty release date to null', () {
      final model = MediaSummaryModel.fromMovieJson(const {
        'id': 1,
        'title': 'Untitled',
        'overview': '',
        'release_date': '',
        'vote_average': 0,
        'vote_count': 0,
      });

      expect(model.releaseDate, isNull);
    });

    test('toEntity maps every field', () {
      final page = loadFixture('movie_popular_page1.json');
      final json = (page['results'] as List).first as Map<String, dynamic>;
      final model = MediaSummaryModel.fromMovieJson(json);

      final entity = model.toEntity();

      expect(entity.id, model.id);
      expect(entity.type, model.type);
      expect(entity.title, model.title);
      expect(entity.overview, model.overview);
      expect(entity.posterPath, model.posterPath);
      expect(entity.backdropPath, model.backdropPath);
      expect(entity.releaseDate, model.releaseDate);
      expect(entity.voteAverage, model.voteAverage);
      expect(entity.voteCount, model.voteCount);
    });
  });
}
