# Personalized Weather Dashboard - Assignment Implementation

## Student Information
- **Student Index**: 194174B (modify this in the app)
- **Platform**: Android (Flutter)
- **API Used**: Open-Meteo (no API key required)

## Features Implemented

### ✅ All Required Features

1. **Student Index Input**
   - Text field for entering student index
   - Pre-filled with sample index: 194174
   - Auto-calculates coordinates when typing

2. **Coordinate Derivation**
   - Formula implemented as specified:
     - `firstTwo = int(index[0..1])`
     - `nextTwo = int(index[2..3])`
     - `lat = 5 + (firstTwo / 10.0)`
     - `lon = 79 + (nextTwo / 10.0)`
   - Displays latitude and longitude to 2 decimal places

3. **Weather API Integration**
   - API: `https://api.open-meteo.com/v1/forecast`
   - Fetches current weather based on derived coordinates
   - Displays:
     - Temperature (°C)
     - Wind speed (km/h)
     - Weather code (raw number)

4. **Request URL Display**
   - Full API request URL shown at bottom of weather card
   - Small, monospaced font for verification

5. **Last Update Time**
   - Shows timestamp from device clock
   - Format: YYYY-MM-DD HH:MM:SS

6. **Loading Indicator**
   - Circular progress indicator shown while fetching
   - Button disabled during loading

7. **Error Handling**
   - User-friendly error messages
   - Red error card with icon
   - Falls back to cached data on network failure

8. **Offline Caching**
   - Uses `shared_preferences` package
   - Caches last successful weather result
   - Shows "(cached)" tag when displaying offline data
   - Automatically loads cached data on app start

## Implementation Details

### Files Created/Modified

1. **lib/main.dart**
   - Main UI implementation
   - Weather dashboard with all required features
   - Responsive Material Design 3 UI

2. **lib/weather_service.dart**
   - Coordinate derivation logic
   - API integration with Open-Meteo
   - Caching functionality
   - Error handling with fallback to cache

3. **pubspec.yaml**
   - Added dependencies:
     - `http: ^1.1.0` - For API calls
     - `shared_preferences: ^2.2.2` - For local caching

### Coordinate Calculation Example

For index `194174`:
- First two digits: `19`
- Next two digits: `41`
- Latitude: `5 + (19 / 10.0) = 6.90°`
- Longitude: `79 + (41 / 10.0) = 83.10°`

### API Request Example

```
https://api.open-meteo.com/v1/forecast?latitude=6.9&longitude=83.1&current_weather=true
```

### Response Data Structure

The app extracts the following from the API response:
```json
{
  "current_weather": {
    "temperature": 27.5,
    "windspeed": 8.2,
    "weathercode": 3
  }
}
```

## How to Use the App

1. **Launch the app** on an Android device/emulator
2. **Enter your student index** in the text field (or modify the pre-filled one)
3. **View derived coordinates** displayed automatically
4. **Tap "Fetch Weather"** button to retrieve weather data
5. **View weather information** including temperature, wind speed, and weather code
6. **Check the request URL** at the bottom for verification
7. **Test offline mode** by turning off internet - cached data will display with "(cached)" tag

## Testing Scenarios

### ✅ Normal Operation
- Enter valid index → See coordinates → Fetch weather → Display results

### ✅ Offline Mode
- Fetch weather once (to cache)
- Turn off internet
- Restart app
- Cached data loads automatically with "(cached)" tag

### ✅ Error Handling
- Invalid index format → Error message shown
- Network error → Falls back to cached data if available

### ✅ Different Indices
Test with different student indices to see different coordinates:
- `194174` → Lat: 6.90°, Lon: 83.10°
- `200550` → Lat: 7.00°, Lon: 84.50°
- `155020` → Lat: 6.50°, Lon: 79.00°

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.1.0
  shared_preferences: ^2.2.2
```

## Build Instructions

1. Ensure Flutter is installed and configured
2. Clone/download the project
3. Run `flutter pub get` to install dependencies
4. Connect Android device or start emulator
5. Run `flutter run -d <device_id>`

## Screenshots

The app includes:
- Clean, modern Material Design 3 UI
- Card-based layout for organized information
- Icons for visual clarity
- Color-coded error messages
- Loading states for better UX
- Responsive layout that works on all screen sizes

## Notes

- The app requires internet permission (already configured in AndroidManifest.xml)
- Open-Meteo API is free and requires no API key
- Weather codes are displayed as raw numbers (as specified)
- Cached data persists across app restarts
- All requirements from the assignment specification are fully implemented

## Weather Code Reference (Optional Enhancement)

Common weather codes from Open-Meteo:
- 0: Clear sky
- 1-3: Partly cloudy
- 45, 48: Fog
- 51-67: Rain
- 71-77: Snow
- 80-99: Rain showers/thunderstorms

(This is for reference only - the app displays raw codes as required)
