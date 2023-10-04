import 'package:flutter/material.dart';
import 'package:gwfront/login.dart';
import 'package:flutter/services.dart';
import 'package:gwfront/recomendationspage.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      );
}
