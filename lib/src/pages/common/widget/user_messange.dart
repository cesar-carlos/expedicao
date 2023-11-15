import 'package:flutter/material.dart';

class UserMessange extends StatelessWidget {
  final String messange;
  const UserMessange({super.key, required this.messange});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          const Center(
            child: Image(
              alignment: Alignment.center,
              fit: BoxFit.cover,
              image: AssetImage('assets/images/log_white.png'),
            ),
          ),
          Positioned(
            bottom: size.height * 0.0,
            child: Container(
              alignment: Alignment.center,
              width: size.width,
              height: 75,
              color: Colors.red.withOpacity(0.3),
              child: Text(
                messange,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
