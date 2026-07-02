const String _tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';

String buildPosterUrl(String posterPath) =>
    '$_tmdbImageBaseUrl/w342$posterPath';

String buildBackdropUrl(String backdropPath) =>
    '$_tmdbImageBaseUrl/w780$backdropPath';
