class AppError extends Error {
  final int errorCode;
  final String message;
  final String details;

  AppError(this.errorCode, this.message, {this.details = ''});

  @override
  String toString() {
    return 'AppError{localError: $errorCode, message: $message, details: $details}';
  }
}
