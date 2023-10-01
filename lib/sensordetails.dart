import 'package:flutter/material.dart';
import 'package:gwfront/login.dart';
import 'package:gwfront/profilepage.dart';
import 'package:gwfront/recomendationspage.dart';
import 'package:gwfront/sensorspage.dart';
import 'package:gwfront/recomendationspage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'test_map_page.dart';
import 'newsensor.dart'; // Import the RecommendationsPage

class SensorDetails extends StatelessWidget {
  String? sensorName;
  String? humidity;
  String? temperature;
  String? nitrogen;
  String? phosphorous;
  String? potassium;
  SensorDetails(
      {this.sensorName,
      this.humidity,
      this.temperature,
      this.nitrogen,
      this.phosphorous,
      this.potassium});

  final List<String> recommendations = [
    "Recommendation 1",
    "Recommendation 2",
    "Recommendation 3",
    // Add more recommendations here as needed
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
              child: Image.asset('assets/profileimg.png'),
              decoration: BoxDecoration(
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
                  text: "Alex",
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
                  MaterialPageRoute(
                    builder: (context) => Sensors(),
                  ),
                );
              },
              child: Image.asset(
                'assets/minilogo.png',
                height: AppBar().preferredSize.height - 16,
              ),
            ),
          ],
        ),
        body: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          MapSD(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
          Divider(
            height: 3,
            color: Colors.grey,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  color: Colors.white, // Background color
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.02),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.0,
                              ),
                              child: Text(
                                sensorName ?? "Sensor",
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
                        Row(
                          children: [
                            Image.asset("assets/humidity.png"),
                            SizedBox(
                              width: 11,
                            ),
                            Text(
                              "Humidity",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                            Spacer(),
                            Text(
                              humidity ?? "?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Image.asset("assets/temperature.png"),
                            SizedBox(
                              width: 11,
                            ),
                            Text(
                              "Temperature",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                            Spacer(),
                            Text(
                              temperature ?? "?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                            SizedBox(
                              width: 11,
                            ),
                            Text(
                              "°C",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Image.asset("assets/nutrients.png"),
                            SizedBox(
                              width: 11,
                            ),
                            Text(
                              "Nitrogen",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                            Spacer(),
                            Text(
                              nitrogen ?? "?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                            SizedBox(
                              width: 11,
                            ),
                            Text(
                              "mg/kg",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Image.asset("assets/nutrients.png"),
                            SizedBox(
                              width: 11,
                            ),
                            Text(
                              "Phosphorus",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                            Spacer(),
                            Text(
                              phosphorous ?? "?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                            SizedBox(
                              width: 11,
                            ),
                            Text(
                              "mg/kg",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Image.asset("assets/nutrients.png"),
                            SizedBox(
                              width: 11,
                            ),
                            Text(
                              "Potassium",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                            Spacer(),
                            Text(
                              potassium ?? "?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                            SizedBox(
                              width: 11,
                            ),
                            Text(
                              "mg/kg",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                          ],
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
                                'Recommendations',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.07,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecommendationsPage(),
                                  ),
                                );
                              },
                              child: Text("See More"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.035,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              color: Color(0xFFFAE392),
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => Recomandations(),
                                  //   ),
                                  // );
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFFAE392),
                                  elevation: 0, // No shadow
                                ),
                                child: Image.asset("assets/ReadMore.png"),
                              ),
                            ),
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
          ),
        ]),
        bottomNavigationBar: NavBarSD(),
      ),
    );
  }
}

class MapSD extends StatelessWidget {
  const MapSD({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height * 0.02),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(46.77945, 23.61126),
                  zoom: 10.0,
                ),
                mapType: MapType.satellite,
                markers: _createMarkers(),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MapScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF8EAC50),
                ),
                child: Text('View map'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarSD extends StatelessWidget {
  const NavBarSD({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          MediaQuery.of(context).size.height * 0.097, // Adjust the height here
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
                        type: PageTransitionType.leftToRightWithFade,
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
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: Profile(),
                        type: PageTransitionType.rightToLeftWithFade,
                        duration: Duration(milliseconds: 500)));
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
    );
  }
}

Set<Marker> _createMarkers() {
  // Create a set of markers to display on the map
  return {
    Marker(
      markerId: MarkerId('marker1'),
      position:
          LatLng(46.810471912910785, 23.584466379240606), // Marker position
      infoWindow: InfoWindow(title: 'Marker 1'), // Marker info window
    ),
    // Add more markers as needed
  };
}
