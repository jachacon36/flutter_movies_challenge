import 'package:flutter_movies_challenge/core/error/result.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_summary.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/paginated_result.dart';
import 'package:flutter_movies_challenge/features/media/domain/repositories/media_repository.dart';

class SearchMedia {
  const SearchMedia(this._repository);

  final MediaRepository _repository;

  Future<Result<PaginatedResult<MediaSummary>>> call({
    required MediaType type,
    required String query,
    required int page,
  }) {
    return _repository.searchMedia(type: type, query: query, page: page);
  }
}
