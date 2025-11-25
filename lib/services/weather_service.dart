import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class WeatherService {
  // Open-Meteo API URL (Free, no key required)
  // Defaulting to a generic location (e.g., London) if no location provided
  // In a real app, we would use the user's location.
  // Lat/Lon for Bucharest, Romania (example)
  final String baseUrl =
      "https://api.open-meteo.com/v1/forecast?latitude=44.4323&longitude=26.1063&current=temperature_2m,relative_humidity_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto&forecast_days=7";

  Future<Map<String, dynamic>> fetchWeather() async {
    try {
      Location location = new Location();
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return {};
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return {};
        }
      }

      _locationData = await location.getLocation();

      final String url =
          "https://api.open-meteo.com/v1/forecast?latitude=${_locationData.latitude}&longitude=${_locationData.longitude}&current=temperature_2m,relative_humidity_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto&forecast_days=7";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print("Error fetching weather: $e");
      return {};
    }
  }

  String getWeatherDescription(int code) {
    // WMO Weather interpretation codes (WW)
    if (code == 0) return "Clear sky";
    if (code == 1 || code == 2 || code == 3)
      return "Mainly clear, partly cloudy, and overcast";
    if (code == 45 || code == 48) return "Fog and depositing rime fog";
    if (code == 51 || code == 53 || code == 55)
      return "Drizzle: Light, moderate, and dense intensity";
    if (code == 61 || code == 63 || code == 65)
      return "Rain: Slight, moderate and heavy intensity";
    if (code == 71 || code == 73 || code == 75)
      return "Snow fall: Slight, moderate, and heavy intensity";
    if (code == 95) return "Thunderstorm: Slight or moderate";
    return "Unknown";
  }
}
