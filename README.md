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

I built this with [Claude Code](https://claude.com/claude-code) as my pair programmer for the whole exercise, given the time budget. Before any code was written, we worked out a full implementation plan together — architecture, task breakdown, GitFlow structure — and I approved it first.

From there, Claude wrote essentially all of the code: the domain layer, the TMDB data mapping, the network client, the Riverpod state management, the UI, and the tests, including capturing real TMDB API fixtures instead of writing them from memory. It also did the mechanical GitFlow work — branching, commits, PR descriptions.

What I did throughout was review and gate every step. Each task landed as its own PR; I read the diff, ran the app, and merged it myself before the next task started, so nothing went in as one big unreviewed dump. The commits are under my own git identity and the PRs are on my own GitHub account, so the history is real — Claude did most of the typing, but under my direction and review at every step.

I'm disclosing this plainly because it's a more honest picture of how I actually work with AI tools than pretending otherwise, and because the exercise asked for it explicitly.
