import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'weather_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const WeatherDashboard(),
    );
  }
}

class WeatherDashboard extends StatefulWidget {
  const WeatherDashboard({super.key});

  @override
  State<WeatherDashboard> createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends State<WeatherDashboard> {
  final TextEditingController _indexController = TextEditingController(text: '194174');
  
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _loadCachedData();
    _calculateCoordinates();
  }

  Future<void> _loadCachedData() async {
    final cachedData = await WeatherService.getCachedData();
    if (cachedData != null && mounted) {
      setState(() {
        _weatherData = cachedData;
        _latitude = cachedData['latitude'];
        _longitude = cachedData['longitude'];
      });
    }
  }

  void _calculateCoordinates() {
    try {
      final coords = WeatherService.deriveCoordinates(_indexController.text);
      setState(() {
        _latitude = coords['lat'];
        _longitude = coords['lon'];
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid index format. Please enter at least 4 digits.';
        _latitude = null;
        _longitude = null;
      });
    }
  }

  Future<void> _fetchWeather() async {
    if (_latitude == null || _longitude == null) {
      setState(() {
        _errorMessage = 'Please enter a valid student index first.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await WeatherService.fetchWeather(_indexController.text);
      if (mounted) {
        setState(() {
          _weatherData = data;
          _latitude = data['latitude'];
          _longitude = data['longitude'];
          _isLoading = false;
        });
        
        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(data['isCached'] == true 
                    ? 'Loaded from cache (offline mode)' 
                    : 'Weather data fetched successfully!'),
              ],
            ),
            backgroundColor: data['isCached'] == true ? Colors.orange : Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to fetch weather: ${e.toString()}\n\nPlease check your internet connection.';
          _isLoading = false;
        });
      }
    }
  }

  String _getWeatherDescription(int code) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Row(
          children: [
            Icon(Icons.wb_sunny_outlined),
            SizedBox(width: 8),
            Text('Weather Dashboard'),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Student Index Input Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.school, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          const Text(
                            'Student Index',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _indexController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Z]')),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          hintText: 'Enter your student index (e.g., 194174)',
                          prefixIcon: const Icon(Icons.edit),
                          helperText: 'At least 4 characters required',
                        ),
                        onChanged: (_) => _calculateCoordinates(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Coordinates Display Card
              if (_latitude != null && _longitude != null)
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            const Text(
                              'Derived Coordinates',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Latitude',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_latitude!.toStringAsFixed(2)}°',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Longitude',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_longitude!.toStringAsFixed(2)}°',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Fetch Weather Button
              ElevatedButton(
                onPressed: _isLoading ? null : _fetchWeather,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Fetching Weather Data...', style: TextStyle(fontSize: 16)),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_download, size: 24),
                          SizedBox(width: 12),
                          Text('Fetch Weather', style: TextStyle(fontSize: 16)),
                        ],
                      ),
              ),
              const SizedBox(height: 16),

              // Error Message Card
              if (_errorMessage != null)
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Error',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Weather Data Display Card
              if (_weatherData != null)
                Card(
                  elevation: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade400,
                          Colors.blue.shade700,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.wb_sunny, color: Colors.white, size: 28),
                                  SizedBox(width: 8),
                                  Text(
                                    'Current Weather',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              if (_weatherData!['isCached'] == true)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade400,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.offline_bolt, color: Colors.white, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        'CACHED',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const Divider(color: Colors.white54, height: 24),
                          
                          // Temperature - Large Display
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  '${_weatherData!['temperature']}°C',
                                  style: const TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _getWeatherDescription(_weatherData!['weathercode']),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Weather Details Grid
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                _buildWeatherDetailRow(
                                  Icons.air,
                                  'Wind Speed',
                                  '${_weatherData!['windspeed']} km/h',
                                ),
                                const Divider(color: Colors.white54, height: 20),
                                _buildWeatherDetailRow(
                                  Icons.code,
                                  'Weather Code',
                                  '${_weatherData!['weathercode']}',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Last Updated
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, color: Colors.white, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Last Updated: ${_formatTimestamp(_weatherData!['timestamp'])}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // API URL Display
                          ExpansionTile(
                            title: const Text(
                              'Request Details',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            iconColor: Colors.white,
                            collapsedIconColor: Colors.white,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SelectableText(
                                  _weatherData!['url'],
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'Courier',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              
              // Info Card
              const SizedBox(height: 16),
              Card(
                color: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Tip: Your last weather fetch is automatically cached for offline access.',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetailRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _indexController.dispose();
    super.dispose();
  }
}
