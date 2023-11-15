class AppDialog {
  final String title;
  final String message;
  final String details;

  AppDialog({
    required this.title,
    required this.message,
    this.details = '',
  });

  @override
  String toString() {
    return 'AppError{message: $message, details: $details}';
  }
}
