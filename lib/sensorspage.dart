import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gwfront/profilepage.dart';
import 'package:gwfront/sensorlist.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'homepage.dart';
import 'login.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'test_map_page.dart';
import 'newsensor.dart';
import 'dart:async';
import 'package:flutter/services.dart';

Map<String, dynamic> usersSensors = {
  "sensors": ["gTsSy0"]
};

class SensorObject {
  String? name;
  bool? humidity;
  double? temperature;
  double? nitrogen;
  double? phosphorous;
  double? potassium;

  SensorObject({
    required this.name,
    required this.humidity,
    required this.temperature,
    required this.nitrogen,
    required this.phosphorous,
    required this.potassium,
  });

  factory SensorObject.fromJson(Map<String, dynamic> json) {
    return SensorObject(
      name: json['name'] ?? "N/A",
      humidity: json['humidity'] ?? 0,
      temperature: json['temperature'] ?? 0,
      nitrogen: json["nitrogen"] ?? 0,
      phosphorous: json["phosphorus"] ?? 0,
      potassium: json["potassium"] ?? 0,
    );
  }
}

Future<List<SensorObject>> fetchData() async {
  final response =
      await http.get(Uri.parse('http://192.168.100.4:8000/sensors/'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body); //?? [];
    final List<SensorObject> mySensors =
        jsonData.map((data) => SensorObject.fromJson(data)).toList();
    return mySensors;
  } else {
    // Error fetching data
    print('1Request failed with status: ${response.statusCode}');
    return [];
  }
}

class Sensors extends StatefulWidget {
  final List<SensorObject>? mySensors;
  Sensors({this.mySensors});
  @override
  _Sensors createState() => _Sensors();
}

class _Sensors extends State<Sensors> {
  List<SensorObject>? mySensorsList;
  List sensor_data = [];
  List sensorsForUser = [];
  _Sensors();

  void getUserData() async {
    final url = Uri.parse(
        'http://192.168.100.4:8000/api/user/1'); // Replace with your Django server URL

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Successful response, handle the data
      //print('Response body: ${response.body}');
      setState(() {
        usersSensors = jsonDecode(response.body);
      });
    } else {
      // Handle errors
      print('2Request failed with status: ${response.statusCode}');
    }
  }

  void getData() async {
    final url = Uri.parse(
        'http://192.168.100.4:8000/apiRest/recommendations/'); // Replace with your Django server URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Successful response, handle the data
      print('Response body: ${response.body}');
      final newData = jsonDecode(response.body);

      setState(() {
        for (final newSensor in newData) {
          final newSensorId = newSensor['sensor_data']['id'];
          final index = sensor_data.indexWhere(
              (sensor) => sensor['sensor_data']['id'] == newSensorId);

          if (index != -1) {
            // If the sensor already exists in the list, update its measurements and recommendations.
            sensor_data[index] = newSensor;
          } else {
            // If the sensor doesn't exist in the list (shouldn't happen as per your clarification), you can decide whether to add it or handle as an anomaly.
            print('Unexpected sensor found with id: $newSensorId');
            sensor_data.add(newSensor);
          }
        }
      });

      // for (var newItem in newData) {
      //   if (!sensor_data.contains(newItem)) {
      //     updatedData.add(newItem);
      //   }
      // }
      //
      // if (updatedData.isNotEmpty) {
      //   setState(() {
      //     sensor_data.addAll(updatedData);
      //   });
      // }
    } else {
      // Handle errors
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Timer? dataFetchTimer;

  void startDataFetching() {
    const Duration fetchInterval = Duration(seconds: 10);

    dataFetchTimer = Timer.periodic(fetchInterval, (timer) {
      getData();
    });
  }

  void startFetching() {
    if (dataFetchTimer == null) {
      startDataFetching();
    }
  }

  void stopFetching() {
    dataFetchTimer?.cancel();
    dataFetchTimer = null;
  }

  @override
  void initState() {
    super.initState();
    startFetching();
    getData();
    getUserData();
    mySensorsList = widget.mySensors;
    if (mySensorsList == null) {
      fetchData().then((sensors) {
        setState(() {
          mySensorsList = sensors;
        });
      });
    }
  }

  void addSensor(SensorObject newSensor) {
    setState(() {
      mySensorsList!.add(newSensor);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    print('Sensor Data: $sensor_data');
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          MapSP(),
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
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
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
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
                            SensorList(
                              sensorName: 'Sensorinio 1',
                              humidity: '1',
                              temperature: '1',
                              nitrogen: '1',
                              phosphorous: '1',
                              potassium: '1',
                              problems: 0,
                            ),
                            if (usersSensors['sensors'] is List) ...[
                              for (final sensorid in usersSensors['sensors'])
                                for (final sensor in sensor_data)
                                  if (sensorid == sensor['sensor_data']['id'])
                                    SensorList(
                                      sensorName: sensor['sensor_data']['name']
                                              as String? ??
                                          'N/A',
                                      humidity: (sensor['sensor_data']
                                                  ['humidity'] as bool?)
                                              ?.toString() ??
                                          'N/A',
                                      temperature: (sensor['sensor_data']
                                                  ['temperature'] as double?)
                                              ?.toString() ??
                                          'N/A',
                                      nitrogen: (sensor['sensor_data']
                                                  ['nitrogen'] as double?)
                                              ?.toString() ??
                                          'N/A',
                                      phosphorous: (sensor['sensor_data']
                                                  ['phosphorus'] as double?)
                                              ?.toString() ??
                                          'N/A',
                                      potassium: (sensor['sensor_data']
                                                  ['potassium'] as double?)
                                              ?.toString() ??
                                          'N/A',
                                      problems: sensor['problem_count'],
                                    )
                            ] else ...[
                              const Text('Loading sensors...'),
                            ]

                            // SensorList(
                            //   sensorName: 'N/A',
                            //   humidity: "True",
                            //   temperature: 'N/A',
                            //   nitrogen: 'N/A',
                            //   phosphorous: 'N/A',
                            //   potassium: 'N/A',
                            //   problems: 1,
                            // ),
                            // SensorList(
                            //   sensorName: 'N/A',
                            //   humidity: "True",
                            //   temperature: 'N/A',
                            //   nitrogen: 'N/A',
                            //   phosphorous: 'N/A',
                            //   potassium: 'N/A',
                            //   problems: 2,
                            // ),
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
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
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
                            child: ListView.builder(
                              itemCount: sensor_data.length,
                              itemBuilder: (context, index) {
                                final sensor = sensor_data[index];
                                final sensorData = sensor["sensor_data"];
                                final sensorId = sensorData["id"];
                                final sensorName = sensorData["name"] ?? 'N/A';

                                if (!usersSensors['sensors']
                                    .contains(sensorId)) {
                                  return Container();
                                }

                                final recommendation = sensor["recommendation"];
                                String temperatureRecommendation = 'N/A';
                                String humidityRecommendation = 'N/A';
                                List<String> nutrientRecommendation = [];

                                if (recommendation is Map<String, dynamic>) {
                                  temperatureRecommendation = recommendation[
                                          "temperature_recommendation"] ??
                                      'N/A';
                                  humidityRecommendation = recommendation[
                                          "humidity_recommendation"] ??
                                      'N/A';
                                  final nutrientRecommendationList =
                                      recommendation["nutrient_recommendation"];
                                  if (nutrientRecommendationList is List) {
                                    nutrientRecommendation =
                                        nutrientRecommendationList
                                            .cast<String>();
                                  }
                                } else if (recommendation is String) {
                                  // If recommendation is a string, use it directly as temperature recommendation
                                  temperatureRecommendation = recommendation;
                                }

                                return ListTile(
                                  title: Text('Sensor Name: $sensorName'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('- $temperatureRecommendation'),
                                      Text('- $humidityRecommendation'),
                                      if (nutrientRecommendation.isNotEmpty)
                                        for (var nutrient
                                            in nutrientRecommendation)
                                          Text('- $nutrient')
                                    ],
                                  ),
                                );
                              },
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
        ],
      ),
    );
  }
}

class MapSP extends StatelessWidget {
  const MapSP({
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
                  backgroundColor: Color(0xFF8EAC50),
                ),
                child: Text(
                  'View map',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Set<Marker> _createMarkers() {
  // Create a set of markers to display on the map
  return {
    Marker(
      markerId: MarkerId('marker1'),
      position: LatLng(46.806844, 23.589411), // Marker position
      infoWindow: InfoWindow(title: 'Marker 1'), // Marker info window
    ),
    Marker(
      markerId: MarkerId('marker1'),
      position: LatLng(46.811815, 23.585164), // Marker position
      infoWindow: InfoWindow(title: 'Marker 2'), // Marker info window
    ),
  };
}
