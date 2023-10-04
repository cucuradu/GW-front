import 'package:flutter/material.dart';
import 'sensordetails.dart';

class Recomandations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RecommendationsPage(),
    );
  }
}

class RecommendationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Color(0xFFFAE392),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Align children at the start (left) horizontally
            children: [
              SizedBox(height: 15), // Empty space to position the image lower
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/image6.png',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height *
                        0.25, // Adjust the height here to make it larger
                    width: MediaQuery.of(context).size.width *
                        0.93, // Adjust the width here to make it larger
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Align children at the start (top) vertically
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15), // Add space to the left of the small image
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SensorDetails()),
                        );
                      },
                      child: Image.asset(
                        'assets/backbutton.png', // Small image on the left
                        height: 50, // Adjust the height of the small image
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ), // Space between the small image and the text
                  Expanded(
                    child: Text(
                      "Nutrients recommendations",
                      style: const TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff000000),
                        height: 32 / 24,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.transparent, // Set the color to transparent
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8), // Equal vertical spacing
                        child:
    
                        Text(
                          "The standard Lorem Ipsum passage, used since the 1500s",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8), // Equal vertical spacing
                          child: Text(
                            // Add your long text here
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              10), // Add space between the title and the next text
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8), // Equal vertical spacing
                        child: Text(
                          "The standard Lorem Ipsum passage, used since the 1500s",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8), // Equal vertical spacing
                          child: Text(
                            // Add your long text here
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
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
