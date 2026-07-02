import 'package:flutter/material.dart';
import 'package:flutter_movies_challenge/core/error/result.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_category.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_summary.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/paginated_result.dart';
import 'package:flutter_movies_challenge/features/media/domain/repositories/media_repository.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_providers.dart';
import 'package:flutter_movies_challenge/features/media/presentation/widgets/media_grid.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockMediaRepository extends Mock implements MediaRepository {}

List<MediaSummary> _page(int page, int count) {
  return List.generate(
    count,
    (index) => MediaSummary(
      id: page * 100 + index,
      type: MediaType.movie,
      title: 'Movie page$page-$index',
      overview: 'Overview',
      posterPath: null,
      backdropPath: null,
      releaseDate: '2026-01-01',
      voteAverage: 7,
      voteCount: 10,
    ),
  );
}

void main() {
  late MockMediaRepository repository;

  const mediaKey = (type: MediaType.movie, category: MediaCategory.popular);

  setUp(() {
    repository = MockMediaRepository();

    when(
      () => repository.getMediaList(
        type: MediaType.movie,
        category: MediaCategory.popular,
        page: 1,
      ),
    ).thenAnswer(
      (_) async => Result.success(
        PaginatedResult(
          items: _page(1, 20),
          page: 1,
          totalPages: 2,
          totalResults: 40,
        ),
      ),
    );

    when(
      () => repository.getMediaList(
        type: MediaType.movie,
        category: MediaCategory.popular,
        page: 2,
      ),
    ).thenAnswer(
      (_) async => Result.success(
        PaginatedResult(
          items: _page(2, 20),
          page: 2,
          totalPages: 2,
          totalResults: 40,
        ),
      ),
    );
  });

  testWidgets('flinging near the bottom loads the next page', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [mediaRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          home: Scaffold(body: MediaGrid(mediaKey: mediaKey)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Movie page1-0'), findsOneWidget);
    verify(
      () => repository.getMediaList(
        type: MediaType.movie,
        category: MediaCategory.popular,
        page: 1,
      ),
    ).called(1);

    // A single fling doesn't necessarily reach the end of a tall grid, so
    // keep flinging towards the bottom until the next page has loaded.
    for (var i = 0; i < 5; i++) {
      await tester.fling(find.byType(GridView), const Offset(0, -3000), 3000);
      await tester.pumpAndSettle();
    }

    verify(
      () => repository.getMediaList(
        type: MediaType.movie,
        category: MediaCategory.popular,
        page: 2,
      ),
    ).called(1);
    expect(find.text('Movie page2-19'), findsOneWidget);
  });
}
