// models/weather_model.dart
class Weather {
  final String city;
  final double temp;
  final String description;
  final double humidity;
  final double windSpeed;

  Weather({
    required this.city,
    required this.temp,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'] ?? 'Unknown City',
      temp: (json['temp'] ?? 0).toDouble(),
      description: json['cloud_pct'].toString(),
      humidity: (json['humidity'] ?? 0).toDouble(),
      windSpeed: (json['wind_speed'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'temp': temp,
    'description': description,
    'humidity': humidity,
    'windSpeed': windSpeed,
  };

  double get tempFahrenheit => (temp * 9 / 5) + 32;
}