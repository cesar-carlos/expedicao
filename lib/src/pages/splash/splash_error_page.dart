import 'package:app_expedicao/src/app/app_color.dart';
import 'package:app_expedicao/src/model/error.message.dart';
import 'package:flutter/material.dart';

class SplashErrorPage extends StatelessWidget {
  final ErrorMessage errorMessage;
  const SplashErrorPage({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox.expand(
        child: Center(
          child: Container(
            width: size.width * 0.8,
            height: size.height * 0.3,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColor.errorColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  errorMessage.title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(color: AppColor.primaryColor),
                const SizedBox(height: 10),
                Text(
                  errorMessage.message,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
