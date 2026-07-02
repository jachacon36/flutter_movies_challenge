import 'package:fluro/fluro.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_movies_challenge/features/media/presentation/screens/detail_screen.dart';
import 'package:flutter_movies_challenge/features/media/presentation/screens/home_screen.dart';
import 'package:flutter_movies_challenge/features/media/presentation/screens/search_screen.dart';

final Handler homeHandler = Handler(
  handlerFunc: (context, params) => const HomeScreen(),
);

final Handler searchHandler = Handler(
  handlerFunc: (context, params) => const SearchScreen(),
);

final Handler mediaDetailHandler = Handler(
  handlerFunc: (context, params) {
    final type = params['type']?.first == 'tv' ? MediaType.tv : MediaType.movie;
    final id = int.parse(params['id']!.first);
    return DetailScreen(mediaKey: (type: type, id: id));
  },
);
