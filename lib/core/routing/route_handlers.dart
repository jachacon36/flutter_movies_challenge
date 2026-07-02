import 'package:fluro/fluro.dart';
import 'package:flutter_movies_challenge/features/media/presentation/screens/home_screen.dart';

final Handler homeHandler = Handler(
  handlerFunc: (context, params) => const HomeScreen(),
);
