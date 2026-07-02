import 'package:flutter/material.dart';
import 'package:flutter_movies_challenge/core/error/result.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_summary.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/paginated_result.dart';
import 'package:flutter_movies_challenge/features/media/domain/repositories/media_repository.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_providers.dart';
import 'package:flutter_movies_challenge/features/media/presentation/screens/search_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockMediaRepository extends Mock implements MediaRepository {}

void main() {
  late MockMediaRepository repository;

  setUpAll(() {
    registerFallbackValue(MediaType.movie);
  });

  setUp(() {
    repository = MockMediaRepository();
    when(
      () => repository.searchMedia(
        type: MediaType.movie,
        query: 'matrix',
        page: 1,
      ),
    ).thenAnswer(
      (_) async => const Result.success(
        PaginatedResult(
          items: [
            MediaSummary(
              id: 603,
              type: MediaType.movie,
              title: 'The Matrix',
              overview: 'Overview',
              posterPath: null,
              backdropPath: null,
              releaseDate: '1999-03-30',
              voteAverage: 8.2,
              voteCount: 100,
            ),
          ],
          page: 1,
          totalPages: 1,
          totalResults: 1,
        ),
      ),
    );
  });

  testWidgets('debounces search input before calling the repository', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [mediaRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: SearchScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'matrix');
    await tester.pump(const Duration(milliseconds: 100));

    verifyNever(
      () => repository.searchMedia(
        type: any(named: 'type'),
        query: any(named: 'query'),
        page: any(named: 'page'),
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));

    verify(
      () => repository.searchMedia(
        type: MediaType.movie,
        query: 'matrix',
        page: 1,
      ),
    ).called(1);

    await tester.pumpAndSettle();
    expect(find.text('The Matrix'), findsOneWidget);
  });
}
