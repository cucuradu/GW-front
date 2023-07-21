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
            GradientContainer(),
            GradientImage(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0xFF17594A),
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF17594A), // #17594A at 100%
            Colors.transparent, // Transparent at 0%
          ],
          stops: [0.0, 1.0],
          begin: Alignment.bottomCenter / 3,
          end: Alignment(
              0.0, -0.5), // The gradient ends at 50% of the screen height
        ),
      ),
    );
  }
}

class GradientImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [
            Colors.transparent, // Transparent at 0%
            Colors.transparent, // Transparent at 0%
            Colors.white, // Solid white at 100%
          ],
          stops: [0.0, 0.2, 1.0],
          begin: Alignment.bottomCenter,
          end: Alignment.bottomCenter / 2,
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: Image.asset(
        'assets/image2.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
