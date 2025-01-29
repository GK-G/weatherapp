// views/weather_screen.dart (updated UI elements)
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import '../viewmodels/weatherviewmodel.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            color: colorScheme.onPrimary,
            onPressed: () => context.read<WeatherViewModel>().fetchWeatherByLocation(),
          ),
          IconButton(
            icon: const Icon(Icons.swap_vert),
            color: colorScheme.onPrimary,
            onPressed: () => context.read<WeatherViewModel>().toggleTemperatureUnit(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary,
              colorScheme.secondary,
              colorScheme.tertiary,
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBar(
                hintText: 'Search city...',
                hintStyle: MaterialStateProperty.all(
                  TextStyle(color: Colors.grey[600]),
                ),
                leading: const Icon(Icons.search, color: Colors.blue),
                onSubmitted: (value) =>
                    context.read<WeatherViewModel>().searchWeather(value),
              ),
            ),
            const Expanded(child: WeatherDisplay()),
          ],
        ),
      ),
    );
  }
}

class WeatherDisplay extends StatelessWidget {
  const WeatherDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vm = context.watch<WeatherViewModel>();

    if (vm.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.onPrimary,
        ),
      );
    }

    if (vm.weather == null) {
      return Center(
        child: Text(
          vm.errorMessage.isEmpty ? 'Search for a city' : vm.errorMessage,
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              vm.weather!.city,
              style: theme.textTheme.displayLarge,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getWeatherIcon(vm.weather!.description),
                size: 100,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '${vm.isCelsius ? vm.weather!.temp.toStringAsFixed(1) : vm.weather!.tempFahrenheit.toStringAsFixed(1)}°${vm.isCelsius ? 'C' : 'F'}',
              style: theme.textTheme.displayLarge,
            ),
            const SizedBox(height: 16),
            Text(
              vm.weather!.description.toUpperCase(),
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildWeatherInfo(
                  context,
                  'Humidity',
                  '${vm.weather!.humidity}%',
                  Feather.droplet,
                ),
                const SizedBox(width: 40),
                _buildWeatherInfo(
                  context,
                  'Wind',
                  '${vm.weather!.windSpeed} m/s',
                  Feather.wind,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String description) {
    if (description.contains('rain')) return Feather.cloud_rain;
    if (description.contains('cloud')) return Feather.cloud;
    if (description.contains('sun')) return Feather.sun;
    return Feather.cloud;
  }

  Widget _buildWeatherInfo(
      BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(label, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.displayMedium?.copyWith(
                fontSize: 20,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}