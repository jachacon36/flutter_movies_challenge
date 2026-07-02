import 'dart:async';

import 'package:flutter_movies_challenge/core/error/result.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_providers.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/search_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _debounceDuration = Duration(milliseconds: 500);

final searchProvider = AsyncNotifierProvider<SearchNotifier, SearchState>(
  SearchNotifier.new,
);

class SearchNotifier extends AsyncNotifier<SearchState> {
  Timer? _debounce;

  @override
  FutureOr<SearchState> build() {
    ref.onDispose(() => _debounce?.cancel());
    return const SearchState.initial();
  }

  void updateQuery(String query) {
    _debounce?.cancel();
    final current = state.valueOrNull ?? const SearchState.initial();
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      state = AsyncData(
        current.copyWith(query: query, items: [], page: 1, hasMore: false),
      );
      return;
    }

    state = AsyncData(current.copyWith(query: query));
    _debounce = Timer(_debounceDuration, () => _search(trimmed));
  }

  void updateType(MediaType type) {
    final current = state.valueOrNull;
    if (current == null || current.type == type) return;

    state = AsyncData(
      current.copyWith(type: type, items: [], page: 1, hasMore: false),
    );

    final trimmed = current.query.trim();
    if (trimmed.isNotEmpty) {
      _search(trimmed);
    }
  }

  Future<void> _search(String query) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final result = await ref.read(searchMediaProvider)(
      type: current.type,
      query: query,
      page: 1,
    );

    state = switch (result) {
      Success(:final value) => AsyncData(
        current.copyWith(
          items: value.items,
          page: value.page,
          hasMore: value.hasMore,
          isLoadingMore: false,
        ),
      ),
      Error(:final failure) => AsyncError(failure, StackTrace.current),
    };
  }

  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null ||
        !current.hasMore ||
        current.isLoadingMore ||
        current.query.trim().isEmpty) {
      return;
    }

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final result = await ref.read(searchMediaProvider)(
      type: current.type,
      query: current.query.trim(),
      page: current.page + 1,
    );

    state = switch (result) {
      Success(:final value) => AsyncData(
        current.copyWith(
          items: [...current.items, ...value.items],
          page: value.page,
          hasMore: value.hasMore,
          isLoadingMore: false,
        ),
      ),
      Error() => AsyncData(current.copyWith(isLoadingMore: false)),
    };
  }
}
