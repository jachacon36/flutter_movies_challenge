import 'package:dio/dio.dart';
import 'package:flutter_movies_challenge/core/error/result.dart';
import 'package:flutter_movies_challenge/core/network/network_exceptions.dart';
import 'package:flutter_movies_challenge/features/media/data/datasources/media_remote_data_source.dart';
import 'package:flutter_movies_challenge/features/media/data/models/media_summary_model.dart';
import 'package:flutter_movies_challenge/features/media/data/models/paginated_response_model.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_category.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_detail.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_summary.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/paginated_result.dart';
import 'package:flutter_movies_challenge/features/media/domain/repositories/media_repository.dart';

class MediaRepositoryImpl implements MediaRepository {
  const MediaRepositoryImpl(this._remoteDataSource);

  final MediaRemoteDataSource _remoteDataSource;

  @override
  Future<Result<PaginatedResult<MediaSummary>>> getMediaList({
    required MediaType type,
    required MediaCategory category,
    required int page,
  }) async {
    try {
      final response = await _remoteDataSource.getMediaList(
        type: type,
        category: category,
        page: page,
      );
      return Result.success(_toPaginatedEntity(response));
    } on DioException catch (e) {
      return Result.failure(mapDioExceptionToFailure(e));
    }
  }

  @override
  Future<Result<MediaDetail>> getMediaDetail({
    required MediaType type,
    required int id,
  }) async {
    try {
      final response = await _remoteDataSource.getMediaDetail(
        type: type,
        id: id,
      );
      return Result.success(response.toEntity());
    } on DioException catch (e) {
      return Result.failure(mapDioExceptionToFailure(e));
    }
  }

  @override
  Future<Result<PaginatedResult<MediaSummary>>> searchMedia({
    required MediaType type,
    required String query,
    required int page,
  }) async {
    try {
      final response = await _remoteDataSource.searchMedia(
        type: type,
        query: query,
        page: page,
      );
      return Result.success(_toPaginatedEntity(response));
    } on DioException catch (e) {
      return Result.failure(mapDioExceptionToFailure(e));
    }
  }

  PaginatedResult<MediaSummary> _toPaginatedEntity(
    PaginatedResponseModel<MediaSummaryModel> response,
  ) {
    return PaginatedResult(
      items: response.results.map((model) => model.toEntity()).toList(),
      page: response.page,
      totalPages: response.totalPages,
      totalResults: response.totalResults,
    );
  }
}
