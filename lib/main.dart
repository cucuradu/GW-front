import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/image2.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Image.asset(
              'assets/gradient.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                  width:
                      350, // Adjust the width and height as per your requirements
                  height: 350,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
