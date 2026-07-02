import 'package:flutter_movies_challenge/core/error/failure.dart';
import 'package:flutter_movies_challenge/core/error/result.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_category.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_summary.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/paginated_result.dart';
import 'package:flutter_movies_challenge/features/media/domain/repositories/media_repository.dart';
import 'package:flutter_movies_challenge/features/media/domain/usecases/get_media_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMediaRepository extends Mock implements MediaRepository {}

void main() {
  late MockMediaRepository repository;
  late GetMediaList useCase;

  setUp(() {
    repository = MockMediaRepository();
    useCase = GetMediaList(repository);
  });

  test('delegates to repository.getMediaList with the given params', () async {
    const expected = PaginatedResult<MediaSummary>(
      items: [],
      page: 1,
      totalPages: 1,
      totalResults: 0,
    );
    when(
      () => repository.getMediaList(
        type: MediaType.movie,
        category: MediaCategory.popular,
        page: 1,
      ),
    ).thenAnswer((_) async => const Result.success(expected));

    final result = await useCase(
      type: MediaType.movie,
      category: MediaCategory.popular,
      page: 1,
    );

    expect(result, isA<Success<PaginatedResult<MediaSummary>>>());
    expect((result as Success).value, expected);
    verify(
      () => repository.getMediaList(
        type: MediaType.movie,
        category: MediaCategory.popular,
        page: 1,
      ),
    ).called(1);
  });

  test('propagates failures from the repository', () async {
    const failure = NetworkFailure();
    when(
      () => repository.getMediaList(
        type: MediaType.tv,
        category: MediaCategory.topRated,
        page: 2,
      ),
    ).thenAnswer((_) async => const Result.failure(failure));

    final result = await useCase(
      type: MediaType.tv,
      category: MediaCategory.topRated,
      page: 2,
    );

    expect(result, isA<Error<PaginatedResult<MediaSummary>>>());
    expect((result as Error).failure, failure);
  });
}
