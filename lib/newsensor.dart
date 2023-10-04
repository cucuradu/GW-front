
import 'package:flutter/material.dart';
import 'package:gwfront/test_map_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gwfront/sensorspage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

List sensor_id = [];

String locationAsString = "";

Map<String, dynamic> sensorsLocation = { };

class NewSensor extends StatefulWidget {
  @override
  _NewSensorState createState() => _NewSensorState();
}

class _NewSensorState extends State<NewSensor> {
  String selectedItem = 'Tomato'; // Default selected item
  TextEditingController IDcontroller = TextEditingController();
  TextEditingController NameController = TextEditingController();
  String? SensorID;
  String? SensorName;
  String? SensorPlant;
  GoogleMapController? mapController;
  Set<Marker> markers = Set();
  Set<Circle> circles = Set();

  List sensor_data = [];

  final MapScreen map = new MapScreen();


  void _getUserLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("Location services are disabled, and user did not enable them.");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permissions are denied.");
        return;
      }
    }

    locationData = await location.getLocation();
    LatLng userLocation =
    LatLng(locationData.latitude!, locationData.longitude!);

    setState(() {
      locationAsString = "${userLocation.latitude},${userLocation.longitude}";
    });

    print("User Location: ${userLocation.latitude}, ${userLocation.longitude}");
  }

  //ADD LOCATION
  Future<void> addSensorLocationToSensor(String? sensorId, String location) async {
    final url = Uri.parse('http://192.168.100.29:8000/sensor/add_location/$sensorId/');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'location': location}),
      );

      if (response.statusCode == 200) {
        // The location has been successfully update
        print('Location added successfully');
      } else if (response.statusCode == 404) {
        print('Request failed with status: ${response.statusCode}');
        // Handle the case where the sensor is not found
      } else {
        print('Request failed with status: ${response.statusCode}');
        // Handle other error cases here
      }
    } catch (e) {
      print('Failed to add location: $e');
    }
  }

  //GET LOCATION
  void getSensorLocation() async {
    final url = Uri.parse(
      'http://192.168.100.29:8000/sensor/get_location/$SensorID/'
    );

    final response = await http.get(url);

    if(response.statusCode == 200){
      print('LOCATIONNNNN: ${response.body}');
      setState(() {
        sensorsLocation = jsonDecode(response.body);
      });
    } else {
      print('Request failed with status: ${response.statusCode}');
    }

  }

  void getData() async {
    final url = Uri.parse(
        'http://192.168.100.29:8000/apiRest/recommendations/'); // Replace with your Django server URL

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Successful response, handle the data
      print('Response body: ${response.body}');
      setState(() {
        sensor_data = jsonDecode(response.body);
      });
    } else {
      // Handle errors
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> addSensorToUser(String? sensorId) async {

    final url = 'http://192.168.100.29:8000/api/add_sensors_to_user/3/';

    final headers = {'Content-Type': 'application/json'};

    final payload = {'sensor_ids': [sensorId]}; // Wrap the sensor ID in a list

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        // Request was successful, handle the response here
        print('Sensor added successfully');
      } else {
        // Request failed, handle error here
        print('Failed to add sensor: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }


  void updateData() async {
    final String apiUrl = 'http://192.168.100.29:8000/api/update_sensors/';

    String sensorDataListJson = jsonEncode(sensor_data);

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: sensorDataListJson,
    );

    if (response.statusCode == 200) {
      print('PUT request successful');
    } else {
      print('PUT request failed with status code: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void _addMarker(LatLng location) {
    final Marker newMarker = Marker(
      markerId: MarkerId(location.toString()),
      position: location,
      infoWindow: InfoWindow(
        title: 'Marker Location',
        snippet: '${location.latitude}, ${location.longitude}',
      ),
    );
    final Circle circle = Circle(
      circleId: CircleId(location.toString() + '_circle'),
      center: location,
      radius: 10, // Adjust the radius as needed (in meters)
      fillColor:
          Colors.blue.withOpacity(0.3), // Set a uniform color (e.g., blue)
      strokeWidth: 2,
      strokeColor: Colors.blue, // Set the circle border color (e.g., blue)
    );

    _addMarkerToSet(newMarker, circle);
  }

  void _addMarkerToSet(Marker marker, Circle circle) {
    setState(() {
      markers.add(marker);
      circles.add(circle);
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
        backgroundColor: Colors.transparent, // Set background to transparent
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/image2.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Image.asset(
                        'assets/Rectangle1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment:
                          Alignment.topCenter, // Center align the content
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.height * 0.02),
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.13,
                            ),
                            Center(
                              child: Text(
                                'Add new sensor',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.09,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.084,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.02,
                                  vertical: MediaQuery.of(context).size.height *
                                      0.01),
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.08,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: IDcontroller,
                                decoration: InputDecoration(
                                  hintText: 'Sensor ID',
                                  hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.02,
                                  vertical: MediaQuery.of(context).size.height *
                                      0.01),
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.08,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: NameController,
                                decoration: InputDecoration(
                                  hintText: 'Sensor name',
                                  hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.02,
                                  vertical: MediaQuery.of(context).size.height *
                                      0.01),
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.08,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<String>(
                                dropdownColor: const Color(0xFF8EAC50),
                                isExpanded: true,
                                value: selectedItem,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedItem = newValue!;
                                  });
                                },
                                icon: Icon(
                                  Icons
                                      .arrow_drop_down, // Set the dropdown arrow to white
                                  color: Colors.white,
                                ),
                                underline: Container(
                                  // Remove the underline by providing an empty container
                                  height: 0,
                                  color: Colors.transparent,
                                ),
                                items: <String>[
                                  'Tomato',
                                  'Cucumber',
                                  'Carrot',
                                  'Potato',
                                  'Another',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.255,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.08,
                              margin: EdgeInsets.only(bottom: 16),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    SensorID = IDcontroller.text;
                                    SensorName = NameController.text;
                                    SensorPlant = selectedItem;
                                  });

                                  for (int i = 0; i < sensor_data.length; i++) {
                                    if (sensor_data[i]["sensor_data"]["id"] ==
                                        SensorID) {
                                      sensor_data[i]["sensor_data"]["name"] =
                                          SensorName;
                                      sensor_data[i]["sensor_data"]["plant"] =
                                          SensorPlant;
                                      break;
                                    }
                                  }

                                  _getUserLocation();

                                  print("LOCATIONFORUSER HELLLLL: $locationAsString");

                                  addSensorLocationToSensor(SensorID, locationAsString);

                                  updateData();

                                  sensor_id.add(SensorID);

                                  addSensorToUser(SensorID);

                                  getSensorLocation();

                                  getData();

                                  _getUserLocation();

                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: Sensors(),
                                          type: PageTransitionType.fade,
                                          duration:
                                              Duration(milliseconds: 400)));
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xFF8EAC50)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8), // Rounded corners
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Add Sensor', // Text for the button
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
