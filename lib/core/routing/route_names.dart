abstract final class RouteNames {
  static const String home = '/';
  static const String search = '/search';
  static const String mediaDetail = '/media/:type/:id';

  static String buildMediaDetailPath({required String type, required int id}) {
    return '/media/$type/$id';
  }
}
