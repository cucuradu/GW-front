import 'package:flutter/material.dart';
import 'package:gwfront/sensordetails.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/services.dart';

class SensorList extends StatelessWidget {
  String? sensorName;
  String? humidity;
  String? temperature;
  String? nitrogen;
  String? phosphorous;
  String? potassium;
  int? problems;

  SensorList({
    super.key,
    this.sensorName,
    this.humidity,
    this.temperature,
    this.nitrogen,
    this.phosphorous,
    this.potassium,
    this.problems,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Provide fake fallback data
    final String displayName = sensorName ?? "Demo Sensor";
    final String displayHumidity = humidity ?? "45%";
    final String displayTemperature = temperature ?? "22°C";
    final String displayNitrogen = nitrogen ?? "50";
    final String displayPhosphorous = phosphorous ?? "30";
    final String displayPotassium = potassium ?? "40";
    final int displayProblems = problems ?? 0;

    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.005,
        right: MediaQuery.of(context).size.width * 0.005,
        bottom: MediaQuery.of(context).size.height * 0.015,
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              child: SensorDetails(
                sensorName: displayName,
                humidity: displayHumidity,
                temperature: displayTemperature,
                nitrogen: displayNitrogen,
                phosphorous: displayPhosphorous,
                potassium: displayPotassium,
              ),
              type: PageTransitionType.rightToLeftWithFade,
              duration: Duration(seconds: 1),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          height: 57,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: MediaQuery.of(context).size.width * 0.055,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircleAvatar(
                backgroundColor: displayProblems == 0
                    ? Colors.green
                    : displayProblems == 1
                        ? Colors.yellow
                        : Colors.red,
                child: Icon(
                  displayProblems == 0 ? Icons.check : Icons.close,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
