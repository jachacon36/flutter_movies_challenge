import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_movies_challenge/core/routing/app_router.dart';
import 'package:flutter_movies_challenge/core/routing/navigation_service.dart';
import 'package:flutter_movies_challenge/core/routing/route_names.dart';
import 'package:flutter_movies_challenge/core/theme/app_theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final appRouter = AppRouter()..configureRoutes();
  final navigationService = NavigationService();
  runApp(
    ProviderScope(
      child: MoviesApp(
        appRouter: appRouter,
        navigationService: navigationService,
      ),
    ),
  );
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({
    required this.appRouter,
    required this.navigationService,
    super.key,
  });

  final AppRouter appRouter;
  final NavigationService navigationService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Movies Challenge',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      navigatorKey: navigationService.navigatorKey,
      onGenerateRoute: appRouter.onGenerateRoute,
      initialRoute: RouteNames.home,
    );
  }
}
