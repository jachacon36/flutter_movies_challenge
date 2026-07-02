import 'package:flutter_movies_challenge/core/error/result.dart';
import 'package:flutter_movies_challenge/core/routing/app_router.dart';
import 'package:flutter_movies_challenge/core/routing/navigation_service.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_category.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_detail.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_summary.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/paginated_result.dart';
import 'package:flutter_movies_challenge/features/media/domain/repositories/media_repository.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_providers.dart';
import 'package:flutter_movies_challenge/features/media/presentation/screens/detail_screen.dart';
import 'package:flutter_movies_challenge/features/media/presentation/widgets/media_card.dart';
import 'package:flutter_movies_challenge/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockMediaRepository extends Mock implements MediaRepository {}

const _summary = MediaSummary(
  id: 603,
  type: MediaType.movie,
  title: 'The Matrix',
  overview: 'Overview',
  posterPath: null,
  backdropPath: null,
  releaseDate: '1999-03-30',
  voteAverage: 8.2,
  voteCount: 100,
);

const _detail = MediaDetail(
  id: 603,
  type: MediaType.movie,
  title: 'The Matrix',
  overview: 'Overview',
  posterPath: null,
  backdropPath: null,
  releaseDate: '1999-03-30',
  voteAverage: 8.2,
  voteCount: 100,
  genres: ['Action'],
  runtime: 136,
);

void main() {
  late MockMediaRepository repository;

  setUpAll(() {
    registerFallbackValue(MediaType.movie);
    registerFallbackValue(MediaCategory.popular);
  });

  setUp(() {
    repository = MockMediaRepository();
    when(
      () => repository.getMediaList(
        type: any(named: 'type'),
        category: any(named: 'category'),
        page: any(named: 'page'),
      ),
    ).thenAnswer(
      (_) async => const Result.success(
        PaginatedResult(
          items: [_summary],
          page: 1,
          totalPages: 1,
          totalResults: 1,
        ),
      ),
    );
    when(
      () => repository.getMediaDetail(type: MediaType.movie, id: 603),
    ).thenAnswer((_) async => const Result.success(_detail));
  });

  testWidgets('tapping a media card navigates to the detail screen', (
    tester,
  ) async {
    final appRouter = AppRouter()..configureRoutes();
    final navigationService = NavigationService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mediaRepositoryProvider.overrideWithValue(repository),
          navigationServiceProvider.overrideWithValue(navigationService),
        ],
        child: MoviesApp(
          appRouter: appRouter,
          navigationService: navigationService,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(MediaCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(DetailScreen), findsOneWidget);
    expect(find.text('The Matrix'), findsWidgets);
  });
}
