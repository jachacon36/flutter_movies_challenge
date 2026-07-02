# Flutter Movies Challenge

A Movies/TV Shows browsing app built with Flutter, consuming [The Movie Database (TMDB)](https://developers.themoviedb.org/3) API. Built as a technical exercise following Clean Architecture, SOLID principles, and a feature-first module structure.

## Features

- Popular and Top Rated listings for Movies and TV Shows, with infinite scroll pagination.
- Movie/TV Show detail screen.
- Search by title, with debounce.
- Unit and widget tests covering domain, data, and presentation layers.

## Tech stack

- **State management**: `hooks_riverpod` + `flutter_hooks`
- **HTTP client**: `dio`
- **Immutable models / codegen**: `freezed` + `json_serializable`
- **Routing**: `fluro`
- **Testing**: `flutter_test` + `mocktail`

## Architecture

The project follows Clean Architecture with a feature-first layout:

```
lib/
  core/          shared network client, error handling, theme, routing, utils
  features/
    media/
      domain/        entities, repository interfaces, use cases
      data/          models, remote data source, repository implementation
      presentation/  providers, screens, widgets
```

`domain` has no dependency on Dio, fluro, or Riverpod — it only depends on plain Dart. This keeps the business logic testable and framework-agnostic, and any new feature can be added by replicating this same three-layer structure without touching `core` or existing features.

### Why `fluro` for routing

`fluro` was chosen per the exercise's explicit recommendation, even though it hasn't seen a new release in a few years. It is still a maintained, null-safe package on pub.dev with no reported incompatibilities against the Flutter/Dart versions used here.

## Git workflow

This repository follows **GitFlow**:

- `main` — always stable/releasable.
- `develop` — integration branch.
- `feature/*` — one branch per task, opened as a pull request into `develop`.
- `release/*` — cut from `develop` before merging into `main`, tagged as a version.

## Getting started

1. Install Flutter 3.35.7 or newer (this project was built with Flutter 3.38.9 / Dart 3.10.8).
2. Copy the environment template and fill in your own TMDB credentials:
   ```
   cp .env.example .env
   ```
3. Install dependencies:
   ```
   flutter pub get
   ```
4. Generate the freezed/json_serializable code:
   ```
   dart run build_runner build --delete-conflicting-outputs
   ```
5. Run the app:
   ```
   flutter run
   ```
6. Run the tests:
   ```
   flutter test
   ```

## What's left / known limitations

This section will be updated as the project progresses. See the final entry before the `release/1.0.0` tag for the complete list of what was and wasn't completed.

## AI usage disclosure

This project was built with the assistance of Claude Code (Anthropic). This section will be filled in with specifics as development progresses, describing exactly which parts were AI-assisted and how.
