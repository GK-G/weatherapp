import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weathermodel.dart';
import '../services/localstorage.dart';
import '../services/weatherservice.dart';

class WeatherViewModel with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocalStorageService _localStorage = LocalStorageService();

  Weather? _weather;
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isCelsius = true;
  String _searchQuery = '';

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isCelsius => _isCelsius;
  String get searchQuery => _searchQuery;


  Future<void> fetchWeatherByLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Check location permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Fetch weather data using obtained coordinates
      final weather = await _weatherService.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      _weather = weather;
      await _localStorage.saveWeatherData(weather);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to fetch weather data: ${e.toString()}';
      _weather = await _localStorage.getLastWeatherData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> searchWeather(String city) async {
    _isLoading = true;
    _searchQuery = city;
    notifyListeners();

    try {
      final weather = await _weatherService.getWeatherByCity(city);
      _weather = weather;
      await _localStorage.saveWeatherData(weather);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to fetch weather data: ${e.toString()}';
      _weather = await _localStorage.getLastWeatherData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleTemperatureUnit() {
    _isCelsius = !_isCelsius;
    notifyListeners();
  }
}