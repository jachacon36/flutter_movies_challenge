# Flutter Movies Challenge

![CI](https://github.com/jachacon36/flutter_movies_challenge/actions/workflows/ci.yaml/badge.svg)

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
  core/          shared network client, error handling, theme, routing, utils, reusable widgets
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

Scope decisions made deliberately, given the exercise's time budget:

- **Single generic `media` feature** parameterized by `MediaType {movie, tv}` instead of separate `movies`/`tv` modules — more defensible given the time budget, and the domain/data/presentation split still replicates cleanly for a future feature.
- **`MediaDetail` is intentionally trimmed**: fields like `production_companies`, `budget`, `revenue`, `created_by`, full `seasons` detail, and cast/crew are not modeled in the domain entity — TMDB returns them, but the UI doesn't need them for this exercise.
- **List cards don't show genre names** — TMDB's list endpoints only return `genre_ids`, and resolving them to names needs a separate `/genre/movie/list` / `/genre/tv/list` call. Genre chips only appear on the detail screen, which returns full `{id, name}` objects.
- **No offline caching or persistence** — every screen re-fetches from the network; there's no local database or disk cache.
- **No pull-to-refresh** — recovering from an error is a manual "Retry" button (`ErrorView`) that invalidates the relevant provider; no automatic retry/backoff.
- **Theme follows the system only** — no manual light/dark toggle in the UI.
- **No accessibility audit or golden/screenshot tests** — widget tests cover behavior (rendering, pagination, navigation, debounce), not visual regression or a11y semantics beyond Flutter's defaults.
- **English only** — no localization/i18n.
- **Image loading is bare `Image.network`** — no disk/memory cache package (e.g. `cached_network_image`); posters/backdrops re-fetch on scroll-back.

## AI usage disclosure

This project was built with heavy assistance from [Claude Code](https://claude.com/claude-code) (Anthropic's CLI coding agent), used as a pair-programming tool through the whole exercise:

- **Implementation**: every layer (domain entities/use cases, data models and TMDB response mapping, network client, Riverpod state, UI screens/widgets) was written by Claude Code under my direction, task by task, following a plan we defined together before writing any code.
- **Tests**: unit, widget, and the fixture-based data-layer tests were written by Claude Code, including capturing real TMDB API fixtures for the data-layer tests instead of writing them from memory.
- **Process**: the GitFlow branch/PR workflow itself — branch creation, commit messages, PR descriptions — was executed by Claude Code, but I reviewed and merged each pull request task by task rather than accepting one large unreviewed change. All commits carry my own git identity and the PRs were opened under my own GitHub account, so the history reflects work I reviewed and approved at each step, not an unreviewed AI dump.
- **Decisions**: I directed the architecture choices (Clean Architecture layout, `fluro` for routing per the exercise's recommendation, `Result`/`Failure` error handling instead of a functional package, the generic `media` feature scope) and made the calls on trade-offs described in "What's left" above.

<!-- TODO(Armando): review and adjust this section before the release PR — it should describe your actual review process in your own words. -->
