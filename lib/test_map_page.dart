import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class SensorObject {
  String? name;
  String? plant;
  double? temperature;
  double? nitrogen;
  double? phosphorus;
  double? potassium;
  String? id;
  String? location;

  SensorObject({
    this.name,
    this.plant,
    this.temperature,
    this.nitrogen,
    this.phosphorus,
    this.potassium,
    this.id,
    this.location,
  });

  factory SensorObject.fromJson(Map<String, dynamic> json) {
    final sensorData = json['sensor_data'];
    return SensorObject(
      name: sensorData['name'],
      plant: sensorData['plant'],
      temperature: sensorData['temperature']?.toDouble(),
      nitrogen: sensorData['nitrogen']?.toDouble(),
      phosphorus: sensorData['phosphorus']?.toDouble(),
      potassium: sensorData['potassium']?.toDouble(),
      id: sensorData['id'],
      location: sensorData['location'],
    );
  }
}


Future<List<SensorObject>> fetchSensorData() async {
  final response = await http.get(
      Uri.parse('http://192.168.1.7:8000/apiRest/recommendations/'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    List<SensorObject> sensors =
        jsonData.map((data) => SensorObject.fromJson(data)).toList();
    return sensors;
  } else {
    // Handle the error appropriately (e.g., show an error message)
    throw Exception('Failed to load sensor data');
  }
}


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = Set();
  Set<Circle> circles = Set();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8EAC50),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: _getUserLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(46.77945, 23.61126), // San Francisco's coordinates
              zoom: 18.5,
            ),
            markers: markers,
            circles: circles,
            onTap: (LatLng location) {
              _addMarker(location); // Default value is 3, replace with your value
            },
            mapType: MapType.hybrid,
          ),

          Positioned(
            top: 16,
            left: 16,
            child: FloatingActionButton(
              onPressed: _getUserLocation,
              backgroundColor: const Color(0xFF8EAC50),
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
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
      fillColor: const Color(0xFF8EAC50).withOpacity(0.3), // Set a uniform color (e.g., blue)
      strokeWidth: 2,
      strokeColor: const Color(0xFF8EAC50), // Set the circle border color (e.g., blue)
    );

    _addMarkerToSet(newMarker, circle);
  }

  void _addMarkerToSet(Marker marker, Circle circle) {
    setState(() {
      markers.add(marker);
      circles.add(circle);
    });
  }

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

    print("User Location: ${userLocation.latitude}, ${userLocation.longitude}");

    _addMarker(userLocation);

    mapController?.animateCamera(CameraUpdate.newLatLngZoom(userLocation, 18.0));

    // Fetch and print sensor data
    _loadSensorData();
  }

  void _addMarkersForSensors(List<SensorObject> sensors) {
    for (SensorObject sensor in sensors) {
      if (sensor.location != null) {
        LatLng sensorLocation = LatLng(
          double.parse(sensor.location!.split(',')[0]), // Extract latitude
          double.parse(sensor.location!.split(',')[1]), // Extract longitude
        );

        final Marker newMarker = Marker(
          markerId: MarkerId(sensor.id ?? 'N/A'),
          position: sensorLocation,
          infoWindow: InfoWindow(
            title: sensor.name ?? 'Sensor',
            snippet: '${sensorLocation.latitude}, ${sensorLocation.longitude}',
          ),
        );

        final Circle circle = Circle(
          circleId: CircleId(sensor.id ?? 'N/A' + '_circle'),
          center: sensorLocation,
          radius: 10, // Adjust the radius as needed (in meters)
          fillColor: const Color(0xFF8EAC50).withOpacity(0.3), // Set a uniform color (e.g., blue)
          strokeWidth: 2,
          strokeColor: const Color(0xFF8EAC50), // Set the circle border color (e.g., blue)
        );

        _addMarkerToSet(newMarker, circle);
      }
    }
  }

  void _loadSensorData() async {
    try {
      List<SensorObject> sensors = await fetchSensorData();
      // Now you have the sensor data in the 'sensors' list
      // You can use it as needed within your widget

      // Print all the sensor data in the terminal
      for (SensorObject sensor in sensors) {
        print('Sensor ID: ${sensor.id ?? 'N/A'}');
        print('Sensor Name: ${sensor.name ?? 'N/A'}');
        print('Plant: ${sensor.plant ?? 'N/A'}');
        print('Temperature: ${sensor.temperature ?? 'N/A'}');
        print('Nitrogen: ${sensor.nitrogen ?? 'N/A'}');
        print('Phosphorous: ${sensor.phosphorus ?? 'N/A'}');
        print('Potassium: ${sensor.potassium ?? 'N/A'}');
        print('Location: ${sensor.location ?? 'N/A'}'); // Print the location
        print('-------------------------');
      }

      // Add markers for sensors
      _addMarkersForSensors(sensors);
    } catch (e) {
      // Handle errors if the data retrieval fails
      print('Error loading sensor data: $e');
    }
  }
}


Set<Marker> _createMarkers() {
  // Create a set of markers to display on the map
  return {
    Marker(
      markerId: MarkerId('marker1'),
      position:
          LatLng(46.7514415003376, 23.575745852039482), // Marker position
      infoWindow: InfoWindow(title: 'Marker 1'), // Marker info window
    ),
    Marker(
      markerId: MarkerId('marker1'),
      position:
          LatLng(46.75128998512223, 23.575964580017544), // Marker position
      infoWindow: InfoWindow(title: 'Marker 1'), // Marker info window
    ),
    // Add more markers as needed
  };
}

