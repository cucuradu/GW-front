import 'package:flutter/material.dart';
import 'package:gwfront/homepage.dart';
import 'package:gwfront/newsensor.dart';
import 'package:gwfront/sensorspage.dart';
import 'package:page_transition/page_transition.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  Profile({super.key});
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  _Profile();
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
                child: Image.asset('assets/profileimg.png'),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            title: RichText(
              text: const TextSpan(
                text: "Hi, ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.normal,
                ),
                children: [
                  TextSpan(
                    text: "Name",
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
                      PageTransition(
                          child: Sensors(),
                          type: PageTransitionType.leftToRightWithFade,
                          duration: Duration(milliseconds: 500)));
                },
                child: Image.asset(
                  'assets/minilogo.png',
                  height: AppBar().preferredSize.height - 16,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.035),
              Center(
                child: Image.asset(
                  'assets/profileimg.png',
                  height: MediaQuery.of(context).size.height * 0.26,
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.03), // Spațiu între imagine și text
              Text(
                'Name',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width *
                      0.1, // Ajustați dimensiunea fontului după preferințele dvs.
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Divider(
                height: 3,
                color: Colors.grey,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                'E-mail',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width *
                      0.07, // Ajustați dimensiunea fontului după preferințele dvs.
                  fontWeight: FontWeight.bold,
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
                      if (sensor_id.isEmpty) {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Homepage(),
                                type: PageTransitionType.leftToRightWithFade,
                                duration: Duration(milliseconds: 500)));
                      } else {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Sensors(),
                                type: PageTransitionType.leftToRightWithFade,
                                duration: Duration(milliseconds: 500)));
                      }
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
                      Navigator.push(
                          context,
                          PageTransition(
                              child: NewSensor(),
                              type: PageTransitionType.bottomToTop,
                              duration: Duration(milliseconds: 500)));
                    }, // Call the _showAddDialog function when the button is pressed
                    backgroundColor:
                        const Color(0xFF8EAC50), // Set the button color here
                    child: const Icon(Icons.add),
                  ),
                ),
                SizedBox(
                  width: 72,
                  height: 72,
                  child: FloatingActionButton(
                    onPressed: () {},
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
        ));
  }
}
