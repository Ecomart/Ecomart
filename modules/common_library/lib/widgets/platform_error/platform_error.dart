import 'package:flutter/material.dart';

class PlatformError extends StatelessWidget {
  final TextTheme theme = const TextTheme(
    bodyText2: TextStyle(fontSize: 16),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/empty.png',
                package: 'inspireui',
                width: 230,
              ),
              const SizedBox(height: 80),
              Text(
                'This feature can not be displayed\non the Desktop version due to the\nlimit of the framework.',
                style: theme.bodyText2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Text(
                'Don\'t worry, it still works smoothly\non SmartPhone and Ipad version.',
                style: theme.bodyText2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
