import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gwfront/profilepage.dart';
import 'package:gwfront/widgets/modern_sensor_card.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'homepage.dart';
import 'login.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'test_map_page.dart';
import 'newsensor.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:gwfront/config.dart';
import 'package:gwfront/widgets/skeleton_loader.dart';
import 'package:gwfront/widgets/smart_refresh_wrapper.dart';
import 'package:gwfront/utils/haptic_feedback_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  final response = await http.get(Uri.parse('${Config.baseUrl}/sensors/'));

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
  bool _isLoading = true;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  _Sensors();

  void getUserData() async {
    final url = Uri.parse(
        '${Config.baseUrl}/api/user/1'); // Replace with your Django server URL

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
    try {
      final url = Uri.parse('${Config.baseUrl}/apiRest/recommendations/');
      final response = await http.get(url).timeout(Duration(seconds: 10));

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

        setState(() {
          _isLoading = false;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    HapticFeedbackUtil.light();
    getData();
    getUserData();
    _refreshController.refreshCompleted();
    await HapticFeedbackUtil.success();
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

    // Combine user sensors and fetched data
    List<Map<String, dynamic>> displaySensors = [];
    if (usersSensors['sensors'] is List) {
      for (final sensorid in usersSensors['sensors']) {
        for (final sensor in sensor_data) {
          if (sensorid == sensor['sensor_data']['id']) {
            displaySensors.add(sensor);
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Sensors",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              SizedBox(height: 20),

              // Search/Filter Placeholder (Optional)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search sensors...",
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Expanded(
                child: _isLoading
                    ? SkeletonList(itemCount: 3)
                    : SmartRefreshWrapper(
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        child: displaySensors.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.sensors_off,
                                        size: 60, color: Colors.grey[300]),
                                    SizedBox(height: 10),
                                    Text(
                                      "No sensors found",
                                      style: TextStyle(color: Colors.grey[500]),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: displaySensors.length,
                                itemBuilder: (context, index) {
                                  final sensor = displaySensors[index];
                                  final sensorData = sensor['sensor_data'];

                                  return GestureDetector(
                                    onTap: () {
                                      HapticFeedbackUtil.selection();
                                    },
                                    child: ModernSensorCard(
                                      sensorName: sensorData['name'] ??
                                          'Unknown Sensor',
                                      location: "Garden",
                                      temperature:
                                          (sensorData['temperature'] as num?)
                                                  ?.toDouble() ??
                                              0.0,
                                      humidity: (sensorData['humidity'] as num?)
                                              ?.toDouble() ??
                                          0.0,
                                      problemCount:
                                          sensor['problem_count'] ?? 0,
                                    ),
                                  );
                                },
                              ),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              child: NewSensor(isNavigated: true),
              type: PageTransitionType.bottomToTop,
              duration: Duration(milliseconds: 400),
            ),
          );
        },
        backgroundColor: Color(0xFF8EAC50),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
