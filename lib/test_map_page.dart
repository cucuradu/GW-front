import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(MaterialApp(
    home: MapScreen(),
  ));
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: _getMarkerLocation,
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
              _addMarker(location, 5); // Default value is 3, replace with your value
            },
            mapType: MapType.hybrid,
          ),

          Positioned(
            top: 16,
            left: 16,
            child: FloatingActionButton(
              onPressed: _getUserLocation,
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  void _addMarker(LatLng location, int value) {
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
      fillColor: calculateColor(value).withOpacity(0.3),
      strokeWidth: 2,
      strokeColor: calculateColor(value),
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
    LatLng userLocation = LatLng(locationData.latitude!, locationData.longitude!);

    print("User Location: ${userLocation.latitude}, ${userLocation.longitude}");

    _addMarker(userLocation, 5 );

    mapController?.animateCamera(CameraUpdate.newLatLngZoom(userLocation, 18.0));
  }

  void _getMarkerLocation() {
    if (markers.isNotEmpty) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.builder(
            itemCount: markers.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Marker ${index + 1}'),
                onTap: () {
                  _showMarkerLocation(markers.elementAt(index));
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      );
    } else {
      print("No markers available.");
    }
  }

  void _showMarkerLocation(Marker marker) {
    final LatLng markerLocation = marker.position;

    print("Selected Marker Location: ${markerLocation.latitude}, ${markerLocation.longitude}");
  }

  Color calculateColor(int value) {
    if (value == 0) {
      // Red
      return Colors.red;
    } else if (value == 1) {
      // Slightly different shade of red
      return Color(0xFFFF3333); // You can adjust the hex color code
    } else if (value == 2) {
      // Orange
      return Colors.orange;
    } else if (value == 3) {
      // Yellow
      return Colors.yellow;
    } else if (value == 4) {
      // Yellow inclined to green
      return Color(0xFFCCFF33); // You can adjust the hex color code
    } else if (value == 5) {
      // Green
      return Colors.green;
    } else {
      // Default to red for values outside the range (0 to 5)
      return Colors.red;
    }
  }
}
