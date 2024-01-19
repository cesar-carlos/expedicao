import 'package:flutter/material.dart';

abstract class ScanControllerContract {
  abstract bool viewMode;
  abstract TextEditingController scanController;
  abstract FocusNode scanFocusNode;
  void onSubmittedScan(String value);
}
