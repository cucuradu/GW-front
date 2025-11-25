import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class WeatherService {
  final Location _location = Location();

  // Default fallback location (Bucharest, Romania)
  static const double _defaultLat = 44.4268;
  static const double _defaultLon = 26.1025;

  /// Fetch weather data using device location or fallback
  Future<Map<String, dynamic>> fetchWeather() async {
    try {
      // Get user's location
      final locationData = await _getUserLocation();
      final lat = locationData['latitude'] ?? _defaultLat;
      final lon = locationData['longitude'] ?? _defaultLon;

      // Fetch weather from Open-Meteo API (no API key needed!)
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?'
        'latitude=$lat&longitude=$lon'
        '&current=temperature_2m,relative_humidity_2m,weather_code'
        '&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max'
        '&timezone=auto'
        '&forecast_days=7',
      );

      print('Fetching weather from: $url');

      final response = await http.get(url).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Weather API timeout');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Weather data received successfully');
        return data;
      } else {
        print('Weather API error: ${response.statusCode}');
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      print('Weather fetch error: $e');
      // Return mock data as fallback
      return _getMockWeatherData();
    }
  }

  /// Get user's current location with permission handling
  Future<Map<String, double?>> _getUserLocation() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        print('Location service not enabled, requesting...');
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          print('Location service denied');
          return {'latitude': _defaultLat, 'longitude': _defaultLon};
        }
      }

      // Check permission
      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        print('Location permission denied, requesting...');
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          print('Location permission not granted');
          return {'latitude': _defaultLat, 'longitude': _defaultLon};
        }
      }

      // Get location
      print('Getting device location...');
      final locationData = await _location.getLocation().timeout(
        Duration(seconds: 5),
        onTimeout: () {
          print('Location fetch timeout');
          throw Exception('Location timeout');
        },
      );

      print('Location: ${locationData.latitude}, ${locationData.longitude}');
      return {
        'latitude': locationData.latitude,
        'longitude': locationData.longitude,
      };
    } catch (e) {
      print('Location error: $e');
      // Return default location
      return {'latitude': _defaultLat, 'longitude': _defaultLon};
    }
  }

  /// Mock weather data for fallback
  Map<String, dynamic> _getMockWeatherData() {
    return {
      'current': {
        'temperature_2m': 22.5,
        'relative_humidity_2m': 65,
        'weather_code': 1,
      },
      'daily': {
        'temperature_2m_max': [24, 25, 23, 26, 24, 23, 22],
        'temperature_2m_min': [15, 16, 14, 17, 15, 14, 13],
        'precipitation_probability_max': [10, 20, 5, 30, 15, 10, 5],
      },
    };
  }

  /// Get weather description from weather code
  String getWeatherDescription(int code) {
    switch (code) {
      case 0:
        return 'Clear sky';
      case 1:
      case 2:
      case 3:
        return 'Partly cloudy';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rain';
      case 71:
      case 73:
      case 75:
        return 'Snow';
      case 95:
      case 96:
      case 99:
        return 'Thunderstorm';
      default:
        return 'Partly cloudy';
    }
  }
}
