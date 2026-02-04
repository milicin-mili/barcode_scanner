abstract class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiException extends AppException {
  const ApiException(this.statusCode, String message) : super(message);

  final int statusCode;
}

class NotFoundException extends AppException {
  const NotFoundException(String message) : super(message);
}
