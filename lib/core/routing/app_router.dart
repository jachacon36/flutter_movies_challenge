import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_movies_challenge/core/routing/route_handlers.dart';
import 'package:flutter_movies_challenge/core/routing/route_names.dart';

class AppRouter {
  AppRouter() : _router = FluroRouter();

  final FluroRouter _router;

  void configureRoutes() {
    _router.define(RouteNames.home, handler: homeHandler);
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) =>
      _router.generator(settings);
}
