import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? '';
    return Scaffold(
      body: Center(
        child: Text(args),
      ),
    );
  }
}
