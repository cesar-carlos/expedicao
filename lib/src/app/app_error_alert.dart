import 'package:app_expedicao/src/app/app_error.dart';

class AppErrorAlert extends AppError {
  AppErrorAlert(
    super.message, {
    int? locationCode,
    super.location,
    super.details,
  }) : super(code: locationCode);

  int? get locationCode => code;
}
