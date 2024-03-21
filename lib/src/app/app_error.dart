class AppError extends Error {
  final String message;
  final String details;

  AppError(this.message, {this.details = ''});

  @override
  String toString() {
    return 'AppError{ message: $message, details: $details}';
  }
}
