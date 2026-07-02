import 'package:flutter_movies_challenge/core/routing/app_router.dart';
import 'package:flutter_movies_challenge/core/routing/navigation_service.dart';
import 'package:flutter_movies_challenge/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MoviesApp boots and renders the home route', (tester) async {
    final appRouter = AppRouter()..configureRoutes();
    final navigationService = NavigationService();

    await tester.pumpWidget(
      MoviesApp(appRouter: appRouter, navigationService: navigationService),
    );
    await tester.pumpAndSettle();

    expect(find.text('Flutter Movies Challenge'), findsOneWidget);
  });
}
