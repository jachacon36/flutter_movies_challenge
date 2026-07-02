import 'package:flutter_movies_challenge/features/media/data/models/media_detail_model.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/fixture_reader.dart';

void main() {
  group('MediaDetailModel', () {
    test('fromMovieJson parses a real TMDB movie detail response', () {
      final json = loadFixture('movie_detail_603.json');

      final model = MediaDetailModel.fromMovieJson(json);

      expect(model.id, json['id']);
      expect(model.type, MediaType.movie);
      expect(model.title, json['title']);
      expect(model.releaseDate, json['release_date']);
      expect(model.runtime, json['runtime']);
      expect(model.numberOfSeasons, isNull);
      expect(model.numberOfEpisodes, isNull);
      expect(
        model.genres,
        (json['genres'] as List)
            .map((genre) => (genre as Map<String, dynamic>)['name'])
            .toList(),
      );
    });

    test('fromTvJson parses a real TMDB tv detail response', () {
      final json = loadFixture('tv_detail_1396.json');

      final model = MediaDetailModel.fromTvJson(json);

      expect(model.id, json['id']);
      expect(model.type, MediaType.tv);
      expect(model.title, json['name']);
      expect(model.releaseDate, json['first_air_date']);
      expect(model.runtime, isNull);
      expect(model.numberOfSeasons, json['number_of_seasons']);
      expect(model.numberOfEpisodes, json['number_of_episodes']);
    });

    test('toEntity maps every field including genres', () {
      final json = loadFixture('movie_detail_603.json');
      final model = MediaDetailModel.fromMovieJson(json);

      final entity = model.toEntity();

      expect(entity.id, model.id);
      expect(entity.genres, model.genres);
      expect(entity.runtime, model.runtime);
    });
  });
}
