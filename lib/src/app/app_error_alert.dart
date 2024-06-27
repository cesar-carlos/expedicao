class AppErrorAlert extends Error {
  final String message;
  final int? locationCode;
  final String? location;
  final String? details;

  AppErrorAlert(
    this.message, {
    this.locationCode,
    this.location,
    this.details,
  });

  @override
  String toString() {
    return '''
      AppError{
        message: $message, 
        locationCode: $locationCode,
        location: $location,
        details: $details}
    ''';
  }
}
