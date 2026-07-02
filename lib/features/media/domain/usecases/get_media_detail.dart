import 'package:flutter_movies_challenge/core/error/result.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_detail.dart';
import 'package:flutter_movies_challenge/features/media/domain/entities/media_type.dart';
import 'package:flutter_movies_challenge/features/media/domain/repositories/media_repository.dart';

class GetMediaDetail {
  const GetMediaDetail(this._repository);

  final MediaRepository _repository;

  Future<Result<MediaDetail>> call({required MediaType type, required int id}) {
    return _repository.getMediaDetail(type: type, id: id);
  }
}
