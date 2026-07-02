sealed class Failure {
  const Failure(this.message);

  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Invalid API credentials.']);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found.']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unknown error occurred.']);
}
