// services/local_storage_service.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/weathermodel.dart';

class LocalStorageService {
  static const String _weatherKey = 'lastWeather';

  Future<void> saveWeatherData(Weather weather) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weatherKey, weather.toJson().toString());
  }

  Future<Weather?> getLastWeatherData() async {
    final prefs = await SharedPreferences.getInstance();
    final weatherString = prefs.getString(_weatherKey);
    if (weatherString != null) {
      try {
        final weatherJson = jsonDecode(weatherString);
        return Weather.fromJson(weatherJson);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}