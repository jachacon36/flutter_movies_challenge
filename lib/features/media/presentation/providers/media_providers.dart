import 'package:flutter_movies_challenge/core/config/env_config.dart';
import 'package:flutter_movies_challenge/core/network/dio_client.dart';
import 'package:flutter_movies_challenge/features/media/data/datasources/media_remote_data_source.dart';
import 'package:flutter_movies_challenge/features/media/data/repositories/media_repository_impl.dart';
import 'package:flutter_movies_challenge/features/media/domain/repositories/media_repository.dart';
import 'package:flutter_movies_challenge/features/media/domain/usecases/get_media_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final envConfigProvider = Provider<EnvConfig>((ref) => EnvConfig());

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(envConfig: ref.watch(envConfigProvider));
});

final mediaRemoteDataSourceProvider = Provider<MediaRemoteDataSource>((ref) {
  return MediaRemoteDataSource(ref.watch(dioClientProvider).dio);
});

final mediaRepositoryProvider = Provider<MediaRepository>((ref) {
  return MediaRepositoryImpl(ref.watch(mediaRemoteDataSourceProvider));
});

final getMediaListProvider = Provider<GetMediaList>((ref) {
  return GetMediaList(ref.watch(mediaRepositoryProvider));
});
