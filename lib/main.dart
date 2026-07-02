import 'package:flutter/material.dart';
import 'package:flutter_movies_challenge/core/routing/app_router.dart';
import 'package:flutter_movies_challenge/core/routing/navigation_service.dart';
import 'package:flutter_movies_challenge/core/routing/route_names.dart';
import 'package:flutter_movies_challenge/core/theme/app_theme.dart';

void main() {
  final appRouter = AppRouter()..configureRoutes();
  final navigationService = NavigationService();
  runApp(
    MoviesApp(appRouter: appRouter, navigationService: navigationService),
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
