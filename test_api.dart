// Simple test script to verify Open-Meteo API is working
// Run with: dart test_api.dart

import 'dart:convert';
import 'dart:io';

void main() async {
  print('🌤️  Testing Open-Meteo Weather API...\n');
  
  // Test with student index 194174
  final index = '194174';
  final firstTwo = int.parse(index.substring(0, 2));
  final nextTwo = int.parse(index.substring(2, 4));
  
  final lat = 5 + (firstTwo / 10.0);
  final lon = 79 + (nextTwo / 10.0);
  
  print('📍 Student Index: $index');
  print('📍 Calculated Coordinates:');
  print('   - Latitude: ${lat.toStringAsFixed(2)}°');
  print('   - Longitude: ${lon.toStringAsFixed(2)}°\n');
  
  final url = 'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true';
  print('🔗 API URL:\n   $url\n');
  
  try {
    print('⏳ Fetching weather data...');
    
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    
    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final data = json.decode(responseBody);
      
      print('\n✅ API Response Successful!\n');
      print('🌡️  Temperature: ${data['current_weather']['temperature']}°C');
      print('💨 Wind Speed: ${data['current_weather']['windspeed']} km/h');
      print('☁️  Weather Code: ${data['current_weather']['weathercode']}');
      
      final weatherCode = data['current_weather']['weathercode'] as int;
      print('📊 Weather Description: ${getWeatherDescription(weatherCode)}');
      
      print('\n✅ API is working correctly!');
      print('✅ Your Flutter app should work perfectly!\n');
    } else {
      print('\n❌ Error: HTTP ${response.statusCode}');
      print('The API returned an error status code.');
    }
    
    client.close();
  } catch (e) {
    print('\n❌ Error: $e');
    print('Please check your internet connection.');
  }
}

String getWeatherDescription(int code) {
  switch (code) {
    case 0:
      return 'Clear sky ☀️';
    case 1:
      return 'Mainly clear 🌤️';
    case 2:
      return 'Partly cloudy ⛅';
    case 3:
      return 'Overcast ☁️';
    case 45:
    case 48:
      return 'Foggy 🌫️';
    case 51:
    case 53:
    case 55:
      return 'Drizzle 🌦️';
    case 61:
    case 63:
    case 65:
      return 'Rain 🌧️';
    case 71:
    case 73:
    case 75:
      return 'Snow ❄️';
    case 77:
      return 'Snow grains ❄️';
    case 80:
    case 81:
    case 82:
      return 'Rain showers 🌧️';
    case 85:
    case 86:
      return 'Snow showers 🌨️';
    case 95:
      return 'Thunderstorm ⛈️';
    case 96:
    case 99:
      return 'Thunderstorm with hail ⛈️';
    default:
      return 'Unknown';
  }
}
