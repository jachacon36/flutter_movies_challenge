import 'package:flutter_movies_challenge/core/routing/route_names.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';

String mediaDetailPath({required MediaType type, required int id}) {
  return RouteNames.buildMediaDetailPath(type: type.name, id: id);
}
