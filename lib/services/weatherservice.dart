import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weathermodel.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.api-ninjas.com/v1/weather';
  static const String _apiKey = '9uJhYDOrNsu6l3QPu6ggmw==Z2CFmH7XZ2oxQjtm'; // Replace with your API key

  Future<Weather> getWeatherByCity(String city) async {
    final response = await http.get(
      Uri.parse("https://api.api-ninjas.com/v1/weather?city=london"),
      headers: {'X-Api-Key': _apiKey},
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Weather> getWeatherByCoordinates(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?lat=$lat&lon=$lon'),
      headers: {'X-Api-Key': _apiKey},
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}