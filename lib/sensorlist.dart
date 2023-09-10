import 'package:flutter/material.dart';
import 'package:gwfront/sensordetails.dart';
import 'package:page_transition/page_transition.dart';

class SensorList extends StatelessWidget {
  String? sensorName;
  String? humidity;
  String? temperature;
  String? nitrogen;
  String? phosphorous;
  String? potassium;
  SensorList(
      {super.key,
      this.sensorName,
      this.humidity,
      this.temperature,
      this.nitrogen,
      this.phosphorous,
      this.potassium});

  @override
  Widget build(BuildContext context) {
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
                    sensorName: sensorName,
                    humidity: humidity,
                    temperature: temperature,
                    nitrogen: nitrogen,
                    phosphorous: phosphorous,
                    potassium: potassium,
                  ),
                  type: PageTransitionType.rightToLeftWithFade,
                  duration: Duration(seconds: 1)));
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          height: 57,
          child: Row(
            // Use a Row to align the text to the left
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.0,
                ),
                child: Text(
                  sensorName!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
