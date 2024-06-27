class AppError extends Error {
  final String message;
  final int? code;
  final String? location;
  final String? details;

  AppError(
    this.message, {
    this.code,
    this.location,
    this.details,
  });

  @override
  String toString() {
    return '''
      AppError{
        message: $message, 
        code: $code,
        location: $location,
        details: $details}
    ''';
  }
}
