import 'package:flutter/material.dart';

class SensorList extends StatelessWidget {
  const SensorList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.height * 0.035),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.8,
              vertical: MediaQuery.of(context).size.height * 0.01),
          child: Text("Sensor 1"),
          decoration: BoxDecoration(color: Colors.grey),
        ));
  }
}
