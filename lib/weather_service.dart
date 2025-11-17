import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WeatherService {
  // Derive latitude and longitude from student index
  static Map<String, double> deriveCoordinates(String index) {
    if (index.length < 4) {
      throw ArgumentError('Index must be at least 4 characters');
    }

    final firstTwo = int.parse(index.substring(0, 2));
    final nextTwo = int.parse(index.substring(2, 4));

    final lat = 5 + (firstTwo / 10.0);
    final lon = 79 + (nextTwo / 10.0);

    return {'lat': lat, 'lon': lon};
  }

  // Build the API URL
  static String buildApiUrl(double lat, double lon) {
    return 'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true';
  }

  // Fetch weather data from API
  static Future<Map<String, dynamic>> fetchWeather(String index) async {
    final coords = deriveCoordinates(index);
    final lat = coords['lat']!;
    final lon = coords['lon']!;
    final url = buildApiUrl(lat, lon);

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = {
          'temperature': data['current_weather']['temperature'],
          'windspeed': data['current_weather']['windspeed'],
          'weathercode': data['current_weather']['weathercode'],
          'latitude': lat,
          'longitude': lon,
          'url': url,
          'timestamp': DateTime.now().toIso8601String(),
          'isCached': false,
        };

        // Cache the result
        await _cacheWeatherData(result);

        return result;
      } else {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      // Try to load cached data on error
      final cachedData = await _getCachedWeatherData();
      if (cachedData != null) {
        cachedData['isCached'] = true;
        return cachedData;
      }
      rethrow;
    }
  }

  // Cache weather data
  static Future<void> _cacheWeatherData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_weather', json.encode(data));
  }

  // Get cached weather data
  static Future<Map<String, dynamic>?> _getCachedWeatherData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedString = prefs.getString('cached_weather');

    if (cachedString != null) {
      return json.decode(cachedString);
    }
    return null;
  }

  // Get cached data for offline display
  static Future<Map<String, dynamic>?> getCachedData() async {
    final data = await _getCachedWeatherData();
    if (data != null) {
      data['isCached'] = true;
    }
    return data;
  }
}
