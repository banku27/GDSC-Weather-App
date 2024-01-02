import 'dart:convert';
import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_api/model/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const baseUrl = "http://api.openweathermap.org/data/2.5/weather";

  final String apiKey;

  WeatherService(this.apiKey);

  Future<WeatherModel> getWeather(String city) async {
    final response = await http.get(
      Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to get weather : ${response.body}');
    }
  }

  Future<String?> getCurrentCityName() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String? city = placemarks[0].locality;
    log("heahdah${placemarks[0].locality.toString()}");

    return city ?? "";
  }
}
