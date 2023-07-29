import 'package:flutter/material.dart';
import 'package:gwfront/login.dart';

class Homepage extends StatelessWidget {
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
                  text: "John",
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
          // Use a Stack to position the buttons
          children: [
            Container(
              color: Colors.white, // Background color
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.61,
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              child: ElevatedButton(
                onPressed: () {
                  // Your button action goes here
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
                    child: Image.asset('assets/plus.png',
                        height: 60), // Increase the size of the plus button
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.27,
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Center(
                  child: Image.asset('assets/nodata.png'),
                ),
              ),
            ),
          ],
        ),
        // Add the FAB here if needed
        floatingActionButtonAnimator:
            FloatingActionButtonAnimator.scaling, // Add an animation to the FAB
        // Adjust the position of the FAB
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 0.0), // Adjust left padding here
                child: SizedBox(
                  width: 70, // Adjust the width to make it bigger
                  height: 70, // Adjust the height to make it bigger
                  child: FloatingActionButton(
                    onPressed: () {
                      // Your left button action goes here
                    },
                    elevation: 0,
                    backgroundColor: Colors.white, // Set the button color here
                    child: Image.asset(
                      'assets/flower.png',
                      height: MediaQuery.of(context).size.height * 0.16,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 70, // Adjust the width to make it bigger
                height: 70, // Adjust the height to make it bigger
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  backgroundColor:
                      Color(0xFF8EAC50), // Set the button color here
                  child: Image.asset(
                    'assets/whiteplus.png',
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(right: 0.0), // Adjust right padding here
                child: SizedBox(
                  width: 70, // Adjust the width to make it bigger
                  height: 70, // Adjust the height to make it bigger
                  child: FloatingActionButton(
                    onPressed: () {
                      // Your right button action goes here
                    },
                    elevation: 0,
                    backgroundColor: Colors.white, // Set the button color here
                    child: Image.asset(
                      'assets/profile.png',
                      height: MediaQuery.of(context).size.height * 0.16,
                    ),
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
