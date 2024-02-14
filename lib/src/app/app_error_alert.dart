class AppErrorAlert extends Error {
  final String message;
  String? details;

  AppErrorAlert(this.message, {this.details});

  @override
  String toString() {
    return '''
      AppError{
        message: $message, 
        details: $details}
      ''';
  }
}
