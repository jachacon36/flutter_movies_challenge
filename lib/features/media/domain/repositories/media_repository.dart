import 'package:flutter_movies_challenge/core/error/result.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_category.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_detail.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_summary.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/paginated_result.dart';

abstract class MediaRepository {
  Future<Result<PaginatedResult<MediaSummary>>> getMediaList({
    required MediaType type,
    required MediaCategory category,
    required int page,
  });

  Future<Result<MediaDetail>> getMediaDetail({
    required MediaType type,
    required int id,
  });

  Future<Result<PaginatedResult<MediaSummary>>> searchMedia({
    required MediaType type,
    required String query,
    required int page,
  });
}
