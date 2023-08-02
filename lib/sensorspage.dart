import 'package:flutter/material.dart';
import 'package:gwfront/homepage.dart';
import 'package:gwfront/login.dart';
import 'package:gwfront/sensorlist.dart';
import 'register.dart';

class Sensors extends StatefulWidget {
  String? userName;
  List<String>? sensors;
  Sensors({this.userName});
  @override
  _Sensors createState() => _Sensors(userName);
}

class _Sensors extends State<Sensors> {
  String? userName;
  _Sensors(this.userName);
  List<String> sensors = [];

  void addSensor() {
    setState(() {
      sensors.add("Sensor ${sensors.length + 1}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF8EAC50),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          title: RichText(
            text: TextSpan(
              text: "Hi, ",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.normal,
              ),
              children: [
                TextSpan(
                  text: userName ?? "Name",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: Image.asset(
                'assets/minilogo.png',
                height: AppBar().preferredSize.height - 16,
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            Container(
              color: Colors.white, // Background color
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.035),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.02,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/map.png',
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height *
                            0.25, // Adjust the height here
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.035,
                    ),
                    Row(
                      // Use a Row to align the text to the left
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.0,
                          ),
                          child: Text(
                            "Sensor list",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.035,
                    ),
                    Column(
                      children: [
                        for (int i = 0; i < sensors.length; i++)
                          SensorList(
                            sensorName: sensors[i],
                            userName: userName,
                          ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      // Use a Row to align the text to the left
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.0,
                          ),
                          child: Text(
                            'Alerts',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.035,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(color: Color(0xFFFAE392)),
                        height: MediaQuery.of(context).size.height *
                            0.25, // Adjust the height here
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.035,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height *
              0.097, // Adjust the height here
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Homepage(
                          userName: userName,
                        ),
                      ),
                    );
                  },
                  backgroundColor: Colors.white, // Set the button color here
                  elevation: 0,
                  child: Image.asset(
                    'assets/flower.png',
                    height: 77,
                  ),
                ),
              ),
              SizedBox(
                width: 75,
                height: 75,
                child: FloatingActionButton(
                  onPressed: addSensor,
                  backgroundColor:
                      Color(0xFF8EAC50), // Set the button color here
                  child: Image.asset(
                    'assets/whiteplus.png',
                    height: 30,
                  ),
                ),
              ),
              SizedBox(
                width: 72,
                height: 72,
                child: FloatingActionButton(
                  onPressed: () {
                    // Your right button action goes here
                  },
                  backgroundColor: Colors.white, // Set the button color here
                  elevation: 0,
                  child: Image.asset(
                    'assets/profile.png',
                    height: 77,
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
