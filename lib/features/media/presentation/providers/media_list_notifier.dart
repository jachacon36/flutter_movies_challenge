import 'dart:async';

import 'package:flutter_movies_challenge/core/error/result.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_list_key.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_list_state.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final mediaListProvider =
    AsyncNotifierProvider.family<
      MediaListNotifier,
      MediaListState,
      MediaListKey
    >(MediaListNotifier.new);

class MediaListNotifier
    extends FamilyAsyncNotifier<MediaListState, MediaListKey> {
  @override
  FutureOr<MediaListState> build(MediaListKey arg) async {
    final result = await ref.read(getMediaListProvider)(
      type: arg.type,
      category: arg.category,
      page: 1,
    );
    return switch (result) {
      Success(:final value) => MediaListState(
        items: value.items,
        page: value.page,
        hasMore: value.hasMore,
      ),
      Error(:final failure) => throw failure,
    };
  }

  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) {
      return;
    }

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final result = await ref.read(getMediaListProvider)(
      type: arg.type,
      category: arg.category,
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
