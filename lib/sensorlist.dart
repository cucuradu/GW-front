import 'package:flutter/material.dart';
import 'package:gwfront/sensordetails.dart';

class SensorList extends StatelessWidget {
  String? sensorName;
  String? userName;
  SensorList({super.key, this.sensorName, this.userName});

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
            MaterialPageRoute(
                builder: (context) => SensorDetails(
                      userName: userName,
                      sensorName: sensorName,
                    )),
          );
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
