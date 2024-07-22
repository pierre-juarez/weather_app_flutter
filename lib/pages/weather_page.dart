import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app_flutter/models/weather_model.dart';
import 'package:weather_app_flutter/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API KEY
  final _weatherService = WeatherService(''); // Your api key
  WeatherModel? _weather;

  // Fetch weather
  _fetchWeather() async {
    // getCurrent City
    String cityName = await _weatherService.getCurrentCity();
    // get Weather for City
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print("🚀 ~ file: weather_page.dart ~ line: 28 ~ Error en la petición: $e");
    }
  }

  // Weather Animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'lib/assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'lib/assets/clouds.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'lib/assets/rain.json';
      case 'thunderstorm':
        return 'lib/assets/thunder.json';
      case 'clear':
        return 'lib/assets/sunny.json';
      default:
        return 'lib/assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();

    // Fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // City name
              Text(
                _weather?.cityName ?? "loading city...",
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black54),
              ),

              // Animation
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

              // Temperature
              Text(
                "${_weather?.temperature.round()}°C",
                style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.black54),
              ),

              // Weather condition
              Text(
                _weather?.mainCondition ?? "",
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black54),
              )
            ],
          ),
        ),
      ),
    );
  }
}
