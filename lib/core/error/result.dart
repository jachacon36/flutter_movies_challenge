import 'package:flutter_movies_challenge/core/error/failure.dart';

sealed class Result<T> {
  const Result();

  const factory Result.success(T value) = Success<T>;

  const factory Result.failure(Failure failure) = Error<T>;

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Error<T>;

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    final self = this;
    return switch (self) {
      Success<T>() => onSuccess(self.value),
      Error<T>() => onFailure(self.failure),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;
}
