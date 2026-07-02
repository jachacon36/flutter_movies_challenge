import 'package:flutter_movies_challenge/core/error/failure.dart';
import 'package:flutter_movies_challenge/core/error/result.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_detail.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_movies_challenge/features/media/domain/repositories/media_repository.dart';
import 'package:flutter_movies_challenge/features/media/domain/usecases/get_media_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMediaRepository extends Mock implements MediaRepository {}

void main() {
  late MockMediaRepository repository;
  late GetMediaDetail useCase;

  setUp(() {
    repository = MockMediaRepository();
    useCase = GetMediaDetail(repository);
  });

  test(
    'delegates to repository.getMediaDetail with the given params',
    () async {
      const expected = MediaDetail(
        id: 42,
        type: MediaType.movie,
        title: 'Some Movie',
        overview: 'Overview',
        posterPath: '/poster.jpg',
        backdropPath: '/backdrop.jpg',
        releaseDate: '2026-01-01',
        voteAverage: 8.1,
        voteCount: 100,
        genres: ['Action'],
        runtime: 120,
      );
      when(
        () => repository.getMediaDetail(type: MediaType.movie, id: 42),
      ).thenAnswer((_) async => const Result.success(expected));

      final result = await useCase(type: MediaType.movie, id: 42);

      expect(result, isA<Success<MediaDetail>>());
      expect((result as Success).value, expected);
      verify(
        () => repository.getMediaDetail(type: MediaType.movie, id: 42),
      ).called(1);
    },
  );

  test('propagates failures from the repository', () async {
    const failure = NotFoundFailure();
    when(
      () => repository.getMediaDetail(type: MediaType.tv, id: 7),
    ).thenAnswer((_) async => const Result.failure(failure));

    final result = await useCase(type: MediaType.tv, id: 7);

    expect(result, isA<Error<MediaDetail>>());
    expect((result as Error).failure, failure);
  });
}
