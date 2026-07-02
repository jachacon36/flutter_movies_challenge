import 'package:flutter_movies_challenge/core/error/result.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_detail.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_detail_key.dart';
import 'package:flutter_movies_challenge/features/media/presentation/providers/media_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final mediaDetailProvider = FutureProvider.family<MediaDetail, MediaDetailKey>((
  ref,
  key,
) async {
  final result = await ref.watch(getMediaDetailProvider)(
    type: key.type,
    id: key.id,
  );
  return switch (result) {
    Success(:final value) => value,
    Error(:final failure) => throw failure,
  };
});
