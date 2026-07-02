import 'package:dio/dio.dart';
import 'package:flutter_movies_challenge/features/media/data/models/media_detail_model.dart';
import 'package:flutter_movies_challenge/features/media/data/models/media_summary_model.dart';
import 'package:flutter_movies_challenge/features/media/data/models/paginated_response_model.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_category.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';

class MediaRemoteDataSource {
  const MediaRemoteDataSource(this._dio);

  final Dio _dio;

  Future<PaginatedResponseModel<MediaSummaryModel>> getMediaList({
    required MediaType type,
    required MediaCategory category,
    required int page,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/${_typeSegment(type)}/${_categorySegment(category)}',
      queryParameters: {'page': page},
    );
    return PaginatedResponseModel.fromJson(
      response.data!,
      (json) => _parseSummary(type, json! as Map<String, dynamic>),
    );
  }

  Future<MediaDetailModel> getMediaDetail({
    required MediaType type,
    required int id,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/${_typeSegment(type)}/$id',
    );
    return _parseDetail(type, response.data!);
  }

  Future<PaginatedResponseModel<MediaSummaryModel>> searchMedia({
    required MediaType type,
    required String query,
    required int page,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/search/${_typeSegment(type)}',
      queryParameters: {'query': query, 'page': page},
    );
    return PaginatedResponseModel.fromJson(
      response.data!,
      (json) => _parseSummary(type, json! as Map<String, dynamic>),
    );
  }

  String _typeSegment(MediaType type) =>
      type == MediaType.movie ? 'movie' : 'tv';

  String _categorySegment(MediaCategory category) =>
      category == MediaCategory.popular ? 'popular' : 'top_rated';

  MediaSummaryModel _parseSummary(MediaType type, Map<String, dynamic> json) =>
      type == MediaType.movie
      ? MediaSummaryModel.fromMovieJson(json)
      : MediaSummaryModel.fromTvJson(json);

  MediaDetailModel _parseDetail(MediaType type, Map<String, dynamic> json) =>
      type == MediaType.movie
      ? MediaDetailModel.fromMovieJson(json)
      : MediaDetailModel.fromTvJson(json);
}
