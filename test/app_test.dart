import 'package:flutter_movies_challenge/core/error/result.dart';
import 'package:flutter_movies_challenge/core/routing/app_router.dart';
import 'package:flutter_movies_challenge/core/routing/navigation_service.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_category.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/paginated_result.dart';
import 'package:flutter_movies_challenge/features/media/domain/repositories/media_repository.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_providers.dart';
import 'package:flutter_movies_challenge/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockMediaRepository extends Mock implements MediaRepository {}

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
        PaginatedResult(items: [], page: 1, totalPages: 1, totalResults: 0),
      ),
    );
  });

  testWidgets('MoviesApp boots and renders the home route', (tester) async {
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

    expect(find.text('Flutter Movies Challenge'), findsOneWidget);
  });
}
