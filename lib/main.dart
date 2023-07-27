import 'package:flutter/material.dart';
import 'package:gwfront/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Login(),
      );
}
