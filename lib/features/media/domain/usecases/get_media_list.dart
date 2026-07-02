import 'package:flutter_movies_challenge/core/error/result.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_category.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_summary.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/paginated_result.dart';
import 'package:flutter_movies_challenge/features/media/domain/repositories/media_repository.dart';

class GetMediaList {
  const GetMediaList(this._repository);

  final MediaRepository _repository;

  Future<Result<PaginatedResult<MediaSummary>>> call({
    required MediaType type,
    required MediaCategory category,
    required int page,
  }) {
    return _repository.getMediaList(type: type, category: category, page: page);
  }
}
