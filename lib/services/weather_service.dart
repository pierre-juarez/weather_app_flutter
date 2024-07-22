import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_flutter/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const baseURL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<WeatherModel> getWeather(String cityName) async {
    final response = await http.get(Uri.parse('$baseURL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    // getPermission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Fecth the current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Convert the location into a list of placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    // Extract the city name from the first placenark
    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
