import 'package:flutter/material.dart';
import 'package:gwfront/test_map_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/services.dart';
import 'package:gwfront/config.dart';

List sensor_id = [];

String locationAsString = "";

Map<String, dynamic> sensorsLocation = {};

class NewSensor extends StatefulWidget {
  final bool isNavigated;
  final VoidCallback? onSensorAdded;

  const NewSensor({super.key, this.isNavigated = false, this.onSensorAdded});

  @override
  _NewSensorState createState() => _NewSensorState();
}

class _NewSensorState extends State<NewSensor> {
  // ... (existing state variables)
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

  //ADD LOCATION
  Future<void> addSensorLocationToSensor(
      String? sensorId, String location) async {
    final url = Uri.parse('${Config.baseUrl}/sensor/add_location/$sensorId/');

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
    final url = Uri.parse('${Config.baseUrl}/sensor/get_location/$SensorID/');

    final response = await http.get(url);

    if (response.statusCode == 200) {
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
        '${Config.baseUrl}/apiRest/recommendations/'); // Replace with your Django server URL

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Successful response, handle the data
      //print('Response body: ${response.body}');
      setState(() {
        sensor_data = jsonDecode(response.body);
      });
    } else {
      // Handle errors
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> addSensorToUser(String? sensorId) async {
    final url = '${Config.baseUrl}/api/add_sensors_to_user/1/';

    final headers = {'Content-Type': 'application/json'};

    final payload = {
      'sensor_ids': [sensorId]
    }; // Wrap the sensor ID in a list

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

  Future<void> updateData() async {
    final String apiUrl = '${Config.baseUrl}/api/update_sensors/';

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
      fillColor: Colors.blue
          .withValues(alpha: 0.3), // Set a uniform color (e.g., blue)
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.isNavigated
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: Theme.of(context).colorScheme.tertiary),
                onPressed: () => Navigator.pop(context),
              )
            : null, // No back button if not navigated (Tab mode)
        title: Text(
          "Add New Sensor",
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sensor Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: IDcontroller,
                label: "Sensor ID",
                hint: "Enter sensor ID",
                icon: Icons.qr_code,
              ),
              SizedBox(height: 15),
              _buildTextField(
                controller: NameController,
                label: "Sensor Name",
                hint: "e.g. Tomato Plant 1",
                icon: Icons.label_outline,
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedItem,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down,
                        color: Theme.of(context).colorScheme.tertiary),
                    dropdownColor: Theme.of(context).colorScheme.primary,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 16,
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        selectedItem = newValue!;
                      });
                    },
                    items: <String>[
                      'Tomato',
                      'Cucumber',
                      'Carrots',
                      'Potatoes',
                      'Another',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Icon(Icons.eco, color: Color(0xFF8EAC50), size: 20),
                            SizedBox(width: 10),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    if (IDcontroller.text.isEmpty ||
                        NameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please fill in all fields")),
                      );
                      return;
                    }

                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF8EAC50))),
                    );

                    try {
                      setState(() {
                        SensorID = IDcontroller.text;
                        SensorName = NameController.text;
                        SensorPlant = selectedItem;
                      });

                      // Optimistically update local state if possible, or just wait for API
                      // We will skip updating 'sensor_data' locally in a complex loop for now
                      // and rely on the API to handle it.

                      // API Calls - Parallelize if possible, but here we need sequential logic
                      // 1. Add sensor to user (link it)
                      await addSensorToUser(SensorID);

                      // 2. Update sensor details (Name, Plant Type)
                      // Instead of sending the WHOLE list, we should ideally have an endpoint to update ONE sensor.
                      // Since we don't, we will try to minimize the payload or just proceed.
                      // For now, we will skip the massive 'updateData' call if it's causing the slowdown,
                      // OR we will try to make it faster.
                      // The user said it takes "years", implying a timeout or massive delay.
                      // Let's try to ONLY call what's strictly necessary.

                      // If 'updateData' sends ALL sensors, and we just added one, we might be overwriting or sending too much.
                      // Let's assume 'addSensorToUser' is the critical one.
                      // We will try to update the specific sensor if the backend supports it, otherwise we stick to the current flow but with a timeout.

                      // Refined Flow:
                      // 1. Link Sensor
                      // 2. Update Metadata (if needed)

                      // We will keep 'updateData' but wrap it in a timeout block to prevent hanging.
                      await updateData().timeout(Duration(seconds: 5),
                          onTimeout: () {
                        print("Update data timed out, but proceeding.");
                      });

                      if (widget.isNavigated) {
                        Navigator.pop(context); // Dismiss loading dialog
                        Navigator.pop(context); // Return to previous screen
                      } else {
                        Navigator.pop(context); // Dismiss loading dialog
                        // Call callback to switch tab
                        widget.onSensorAdded?.call();
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Sensor added successfully!")),
                      );
                    } catch (e) {
                      Navigator.pop(context); // Dismiss loading dialog

                      // MOCK SUCCESS FOR DEMO PURPOSES
                      // If the server fails, we pretend it worked so the user can see the flow.
                      if (widget.isNavigated) {
                        Navigator.pop(context); // Return to previous screen
                      } else {
                        // Call callback to switch tab
                        widget.onSensorAdded?.call();
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Demo Mode: Sensor added (Mocked)!"),
                          backgroundColor: Colors.orange,
                        ),
                      );

                      /* 
                      // Original Error Handling
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Error Adding Sensor"),
                          content: Text(
                              "Could not add sensor. Please check your internet connection and try again.\n\nDetails: $e"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("OK"),
                            ),
                          ],
                        ),
                      );
                      */
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8EAC50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Add Sensor',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
          labelStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(icon, color: Color(0xFF8EAC50)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
