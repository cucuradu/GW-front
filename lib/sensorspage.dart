import 'package:flutter/material.dart';
import 'package:gwfront/homepage.dart';
import 'package:gwfront/login.dart';
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
        body: Stack(
          children: [
            Container(
              color: Colors.white, // Background color
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.04,
                  right: MediaQuery.of(context).size.width * 0.04,
                  bottom: MediaQuery.of(context).size.height * 0.52,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/map.png',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height *
                        0.25, // Adjust the height here
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.01,
                  right: MediaQuery.of(context).size.width * 0.5,
                  bottom: MediaQuery.of(context).size.height * 0.44,
                ),
                child: Text(
                  'Sensors List',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.03,
                  bottom: MediaQuery.of(context).size.height * 0.35,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.92,
                    height: 50,
                    decoration: BoxDecoration(color: Colors.grey),
                    child: Center(
                      child: Text(
                        'Button',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
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
