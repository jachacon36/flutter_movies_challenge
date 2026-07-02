import 'package:flutter_movies_challenge/core/config/env_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnvConfig', () {
    test('parses v3 auth mode', () {
      final config = EnvConfig(environment: {'TMDB_AUTH_MODE': 'v3'});

      expect(config.authMode, TmdbAuthMode.v3);
    });

    test('parses v4 auth mode', () {
      final config = EnvConfig(environment: {'TMDB_AUTH_MODE': 'v4'});

      expect(config.authMode, TmdbAuthMode.v4);
    });

    test('throws when TMDB_AUTH_MODE is missing or invalid', () {
      final config = EnvConfig(environment: {'TMDB_AUTH_MODE': 'bogus'});

      expect(() => config.authMode, throwsStateError);
    });

    test('returns apiKey when present', () {
      final config = EnvConfig(environment: {'TMDB_API_KEY': 'abc123'});

      expect(config.apiKey, 'abc123');
    });

    test('throws when apiKey is missing', () {
      final config = EnvConfig(environment: const {});

      expect(() => config.apiKey, throwsStateError);
    });

    test('throws when readAccessToken is missing', () {
      final config = EnvConfig(environment: const {});

      expect(() => config.readAccessToken, throwsStateError);
    });
  });
}
