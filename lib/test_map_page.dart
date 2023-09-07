import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Example'),
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
              target: LatLng(37.7749, -122.4194), // San Francisco's coordinates
              zoom: 12.0,
            ),
            markers: markers,
            onTap: (LatLng location) {
              _addMarker(location);
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

  void _addMarker(LatLng location) {
    final Marker newMarker = Marker(
      markerId: MarkerId(location.toString()),
      position: location,
      infoWindow: InfoWindow(
        title: 'Marker Location',
        snippet: '${location.latitude}, ${location.longitude}',
      ),
    );

    _addMarkerToSet(newMarker);
  }

  void _addMarkerToSet(Marker marker) {
    setState(() {
      markers.add(marker);
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
    
    _addMarker(userLocation); // Add a marker for the user's location
    
    mapController?.animateCamera(CameraUpdate.newLatLng(userLocation));
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
                  Navigator.pop(context); // Close the bottom sheet
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
}

void main() => runApp(MaterialApp(home: MapScreen()));
