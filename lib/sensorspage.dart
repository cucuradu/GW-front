import 'package:flutter/material.dart';
import 'package:gwfront/homepage.dart';
import 'package:gwfront/login.dart';
import 'package:gwfront/sensorlist.dart';
import 'register.dart';

class Sensors extends StatefulWidget {
  String? userName;
  Sensors({this.userName});
  @override
  _Sensors createState() => _Sensors(userName);
}

class _Sensors extends State<Sensors> {
  String? userName;
  _Sensors(this.userName);
  var myInitialItem = 'Item 1';
  List<String> myItems = [
    'Sensor 1',
    'Sensor 2',
    'Sensor 3',
    'Sensor 4',
    'Sensor 5'
  ];
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
                color: Color(0xFF8EAC50),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          title: RichText(
            text: TextSpan(
              text: "Hi, ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.normal,
              ),
              children: [
                TextSpan(
                  text: userName ?? "Name",
                  style: TextStyle(
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
                  MaterialPageRoute(builder: (context) => Login()),
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
                    horizontal: MediaQuery.of(context).size.height * 0.02),
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
                        height: MediaQuery.of(context).size.height * 0.035),
                    Text(
                      'Sensors List',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.07,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.035),
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(20),
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width * 0.92,
                    //     height: 50,
                    //     decoration: BoxDecoration(color: Colors.grey),
                    //     child: Center(
                    //       child: Padding(
                    //         padding: EdgeInsets.only(
                    //             left: MediaQuery.of(context).size.width * 0.02,
                    //             right:
                    //                 MediaQuery.of(context).size.width * 0.68),
                    //         child: Text(
                    //           'Sensor 1',
                    //           style: TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SensorList(),
                    Text(
                      'Alerts',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.07,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.035),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(color: Color(0xFFFAE392)),
                        height: MediaQuery.of(context).size.height *
                            0.25, // Adjust the height here
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.035),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Add the custom BottomAppBar here
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
                  onPressed: () {
                    // Your add button action goes here
                  },
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
