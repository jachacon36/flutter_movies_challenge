import 'package:dio/dio.dart';
import 'package:flutter_movies_challenge/core/error/failure.dart';
import 'package:flutter_movies_challenge/core/error/result.dart';
import 'package:flutter_movies_challenge/features/media/data/datasources/media_remote_data_source.dart';
import 'package:flutter_movies_challenge/features/media/data/models/media_detail_model.dart';
import 'package:flutter_movies_challenge/features/media/data/models/media_summary_model.dart';
import 'package:flutter_movies_challenge/features/media/data/models/paginated_response_model.dart';
import 'package:flutter_movies_challenge/features/media/data/repositories/media_repository_impl.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_category.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_detail.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_summary.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/paginated_result.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMediaRemoteDataSource extends Mock implements MediaRemoteDataSource {}

void main() {
  late MockMediaRemoteDataSource dataSource;
  late MediaRepositoryImpl repository;

  setUp(() {
    dataSource = MockMediaRemoteDataSource();
    repository = MediaRepositoryImpl(dataSource);
  });

  group('getMediaList', () {
    const summary = MediaSummaryModel(
      id: 1,
      type: MediaType.movie,
      title: 'Title',
      overview: 'Overview',
      voteAverage: 7.5,
      voteCount: 10,
    );
    const response = PaginatedResponseModel<MediaSummaryModel>(
      page: 1,
      results: [summary],
      totalPages: 5,
      totalResults: 100,
    );

    test('returns a mapped PaginatedResult on success', () async {
      when(
        () => dataSource.getMediaList(
          type: MediaType.movie,
          category: MediaCategory.popular,
          page: 1,
        ),
      ).thenAnswer((_) async => response);

      final result = await repository.getMediaList(
        type: MediaType.movie,
        category: MediaCategory.popular,
        page: 1,
      );

      expect(result, isA<Success<PaginatedResult<MediaSummary>>>());
      final value = (result as Success<PaginatedResult<MediaSummary>>).value;
      expect(value.items, [summary.toEntity()]);
      expect(value.page, 1);
      expect(value.totalPages, 5);
      expect(value.totalResults, 100);
    });

    test('maps a DioException to a Failure', () async {
      when(
        () => dataSource.getMediaList(
          type: MediaType.movie,
          category: MediaCategory.popular,
          page: 1,
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/movie/popular'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.getMediaList(
        type: MediaType.movie,
        category: MediaCategory.popular,
        page: 1,
      );

      expect(result, isA<Error<PaginatedResult<MediaSummary>>>());
      expect(
        (result as Error<PaginatedResult<MediaSummary>>).failure,
        isA<NetworkFailure>(),
      );
    });
  });

  test('getMediaDetail returns a mapped MediaDetail on success', () async {
    const detail = MediaDetailModel(
      id: 603,
      type: MediaType.movie,
      title: 'The Matrix',
      overview: 'Overview',
      voteAverage: 8.7,
      voteCount: 25000,
      genres: ['Action'],
      runtime: 136,
    );
    when(
      () => dataSource.getMediaDetail(type: MediaType.movie, id: 603),
    ).thenAnswer((_) async => detail);

    final result = await repository.getMediaDetail(
      type: MediaType.movie,
      id: 603,
    );

    expect(result, isA<Success<MediaDetail>>());
    expect((result as Success<MediaDetail>).value, detail.toEntity());
  });

  test('searchMedia returns a mapped PaginatedResult on success', () async {
    const summary = MediaSummaryModel(
      id: 2,
      type: MediaType.tv,
      title: 'Show',
      overview: 'Overview',
      voteAverage: 6,
      voteCount: 5,
    );
    const response = PaginatedResponseModel<MediaSummaryModel>(
      page: 1,
      results: [summary],
      totalPages: 1,
      totalResults: 1,
    );
    when(
      () =>
          dataSource.searchMedia(type: MediaType.tv, query: 'office', page: 1),
    ).thenAnswer((_) async => response);

    final result = await repository.searchMedia(
      type: MediaType.tv,
      query: 'office',
      page: 1,
    );

    expect(result, isA<Success<PaginatedResult<MediaSummary>>>());
    expect((result as Success<PaginatedResult<MediaSummary>>).value.items, [
      summary.toEntity(),
    ]);
  });
}
