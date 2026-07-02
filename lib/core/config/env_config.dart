import 'package:flutter_dotenv/flutter_dotenv.dart';

enum TmdbAuthMode { v3, v4 }

class EnvConfig {
  EnvConfig({Map<String, String>? environment})
      : _environment = environment ?? dotenv.env;

  final Map<String, String> _environment;

  TmdbAuthMode get authMode {
    final raw = _environment['TMDB_AUTH_MODE'];
    return switch (raw) {
      'v3' => TmdbAuthMode.v3,
      'v4' => TmdbAuthMode.v4,
      _ => throw StateError(
          'TMDB_AUTH_MODE must be "v3" or "v4", got "$raw".',
        ),
    };
  }

  String get apiKey => _require('TMDB_API_KEY');

  String get readAccessToken => _require('TMDB_API_READ_ACCESS_TOKEN');

  String _require(String key) {
    final value = _environment[key];
    if (value == null || value.isEmpty) {
      throw StateError('Missing required environment variable "$key".');
    }
    return value;
  }
}
