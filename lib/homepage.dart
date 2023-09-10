import 'package:flutter/material.dart';
import 'package:gwfront/login.dart';
import 'package:gwfront/newsensor.dart';
import 'package:gwfront/sensorspage.dart';
import 'package:page_transition/page_transition.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

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
                  text: "Name",
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
          physics: NeverScrollableScrollPhysics(),
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
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: NewSensor(),
                                type: PageTransitionType.bottomToTop,
                                duration: Duration(milliseconds: 500)));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFFAE392),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Center(
                          child: Image.asset('assets/plus.png', height: 60),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.11),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Center(
                        child: Image.asset('assets/nodata.png'),
                      ),
                    ),
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
                        PageTransition(
                            child: Sensors(),
                            type: PageTransitionType.rightToLeftWithFade,
                            duration: Duration(milliseconds: 500)));
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
                  },
                  backgroundColor:
                      const Color(0xFF8EAC50), // Set the button color here
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
