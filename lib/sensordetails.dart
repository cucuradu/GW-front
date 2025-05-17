import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Theme/theme_provider.dart';
import 'login.dart';
import 'profilepage.dart';
import 'recomendationspage.dart';
import 'sensorspage.dart';
import 'test_map_page.dart';
import 'newsensor.dart';

class SensorDetails extends StatefulWidget {
  final String? sensorName;
  final String? humidity;
  final String? temperature;
  final String? nitrogen;
  final String? phosphorous;
  final String? potassium;

  SensorDetails({
    this.sensorName,
    this.humidity,
    this.temperature,
    this.nitrogen,
    this.phosphorous,
    this.potassium,
  });

  @override
  _SensorDetailsState createState() => _SensorDetailsState();
}

class _SensorDetailsState extends State<SensorDetails> {
  int temperatureValue = 0;
  int nitrogenValue = 0;
  int phosphorusValue = 0;
  int potassiumValue = 0;

  @override
  void initState() {
    super.initState();
    parseValues();
  }

  void parseValues() {
    temperatureValue = int.tryParse(
            widget.temperature?.replaceAll(RegExp(r'[^0-9]'), '') ?? '') ??
        0;
    nitrogenValue = int.tryParse(
            widget.nitrogen?.replaceAll(RegExp(r'[^0-9]'), '') ?? '') ??
        0;
    phosphorusValue = int.tryParse(
            widget.phosphorous?.replaceAll(RegExp(r'[^0-9]'), '') ?? '') ??
        0;
    potassiumValue = int.tryParse(
            widget.potassium?.replaceAll(RegExp(r'[^0-9]'), '') ?? '') ??
        0;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
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
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.sensorName ?? "Sensor",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.035),
                      _buildSensorRow("Humidity", widget.humidity ?? "?",
                          "assets/humidity.png"),
                      _buildSensorRow(
                        "Temperature",
                        widget.temperature ?? "?",
                        "assets/temperature.png",
                        suffix: "°C",
                        isInRange:
                            (10 <= temperatureValue && temperatureValue <= 30),
                      ),
                      _buildSensorRow(
                        "Nitrogen",
                        widget.nitrogen ?? "?",
                        "assets/nutrients.png",
                        suffix: "mg/kg",
                        isInRange: (40 <= nitrogenValue && nitrogenValue <= 60),
                      ),
                      _buildSensorRow(
                        "Phosphorus",
                        widget.phosphorous ?? "?",
                        "assets/nutrients.png",
                        suffix: "mg/kg",
                        isInRange:
                            (30 <= phosphorusValue && phosphorusValue <= 50),
                      ),
                      _buildSensorRow(
                        "Potassium",
                        widget.potassium ?? "?",
                        "assets/nutrients.png",
                        suffix: "mg/kg",
                        isInRange:
                            (40 <= potassiumValue && potassiumValue <= 70),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.035),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recommendations',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Recomandations(Name: widget.sensorName),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8EAC50),
                            ),
                            child: Text("See More"),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.035),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Color(0xFFFAE392),
                          ),
                          child: Image.asset(
                            'assets/tomatoes.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.035),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorRow(String label, String value, String iconPath,
      {String? suffix, bool isInRange = true}) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
      child: Row(
        children: [
          Image.asset(iconPath, height: 24),
          SizedBox(width: 11),
          Text(
            label,
            style: TextStyle(
              color: isInRange ? Colors.black : Colors.red,
              fontSize: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              color: isInRange ? Colors.black : Colors.red,
              fontSize: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          if (suffix != null) ...[
            SizedBox(width: 11),
            Text(
              suffix,
              style: TextStyle(
                color: isInRange ? Colors.black : Colors.red,
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class MapSD extends StatelessWidget {
  const MapSD({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.height * 0.02,
      ),
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
                  backgroundColor: Color(0xFF8EAC50),
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

Set<Marker> _createMarkers() {
  return {
    Marker(
      markerId: MarkerId('marker1'),
      position: LatLng(46.7514415, 23.5757458),
      infoWindow: InfoWindow(title: 'Marker 1'),
    ),
    Marker(
      markerId: MarkerId('marker2'),
      position: LatLng(46.75129, 23.5759646),
      infoWindow: InfoWindow(title: 'Marker 2'),
    ),
  };
}
