const String _tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/w342';

String buildPosterUrl(String posterPath) => '$_tmdbImageBaseUrl$posterPath';
