import 'package:dio/dio.dart';
import 'package:flutter_movies_challenge/features/media/data/datasources/media_remote_data_source.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_category.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

Response<Map<String, dynamic>> _responseWith(
  String path,
  Map<String, dynamic> data,
) {
  return Response(
    requestOptions: RequestOptions(path: path),
    data: data,
    statusCode: 200,
  );
}

void main() {
  late MockDio dio;
  late MediaRemoteDataSource dataSource;

  setUp(() {
    dio = MockDio();
    dataSource = MediaRemoteDataSource(dio);
  });

  group('getMediaList', () {
    test('requests /movie/popular and parses movie results', () async {
      final json = loadFixture('movie_popular_page1.json');
      when(
        () => dio.get<Map<String, dynamic>>(
          '/movie/popular',
          queryParameters: {'page': 1},
        ),
      ).thenAnswer((_) async => _responseWith('/movie/popular', json));

      final result = await dataSource.getMediaList(
        type: MediaType.movie,
        category: MediaCategory.popular,
        page: 1,
      );

      expect(result.page, json['page']);
      expect(result.totalPages, json['total_pages']);
      expect(result.results, hasLength((json['results'] as List).length));
      expect(result.results.first.type, MediaType.movie);
    });

    test('requests /tv/top_rated and parses tv results', () async {
      final json = loadFixture('tv_popular_page1.json');
      when(
        () => dio.get<Map<String, dynamic>>(
          '/tv/top_rated',
          queryParameters: {'page': 2},
        ),
      ).thenAnswer((_) async => _responseWith('/tv/top_rated', json));

      final result = await dataSource.getMediaList(
        type: MediaType.tv,
        category: MediaCategory.topRated,
        page: 2,
      );

      expect(result.results.first.type, MediaType.tv);
    });
  });

  group('getMediaDetail', () {
    test('requests /movie/{id} and parses a movie detail', () async {
      final json = loadFixture('movie_detail_603.json');
      when(
        () => dio.get<Map<String, dynamic>>('/movie/603'),
      ).thenAnswer((_) async => _responseWith('/movie/603', json));

      final result = await dataSource.getMediaDetail(
        type: MediaType.movie,
        id: 603,
      );

      expect(result.id, json['id']);
      expect(result.title, json['title']);
    });

    test('requests /tv/{id} and parses a tv detail', () async {
      final json = loadFixture('tv_detail_1396.json');
      when(
        () => dio.get<Map<String, dynamic>>('/tv/1396'),
      ).thenAnswer((_) async => _responseWith('/tv/1396', json));

      final result = await dataSource.getMediaDetail(
        type: MediaType.tv,
        id: 1396,
      );

      expect(result.id, json['id']);
      expect(result.title, json['name']);
      expect(result.numberOfSeasons, json['number_of_seasons']);
    });
  });

  group('searchMedia', () {
    test('requests /search/movie with the query', () async {
      final json = loadFixture('movie_popular_page1.json');
      when(
        () => dio.get<Map<String, dynamic>>(
          '/search/movie',
          queryParameters: {'query': 'matrix', 'page': 1},
        ),
      ).thenAnswer((_) async => _responseWith('/search/movie', json));

      final result = await dataSource.searchMedia(
        type: MediaType.movie,
        query: 'matrix',
        page: 1,
      );

      expect(result.page, json['page']);
    });
  });
}
