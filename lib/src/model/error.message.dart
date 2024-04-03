class ErrorMessage {
  final String title;
  final String message;
  final List<String> erros;

  ErrorMessage({
    required this.title,
    required this.message,
    this.erros = const [],
  });
}
