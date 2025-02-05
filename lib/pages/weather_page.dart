import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // Get user clock time
  Color updateBackgroundColor() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    bool isEvening = hour >= 18 || hour < 6;

    return isEvening ? Colors.black : Colors.white;
  }

  Color updateTextColor() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    bool isEvening = hour >= 18 || hour < 6;

    return isEvening ? Colors.white : Colors.black;
  }

  // Api key
  final _weatherService = WeatherService(apiKey: 'YOUR API KEY');

  WeatherModel? _weatherModel;

  // Fetch weather
  Future<void> _fetchWeather() async {
    // Get current city
    String cityName = await _weatherService.getCurrentCity();

    // Get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weatherModel = weather;
      });
    } catch (e) {
      rethrow;
    }
  }

  // Weather animations
  String getWeatheranimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/animations/sunny.json';

    switch (mainCondition) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'sand':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/animations/rainy_sunny.json';
      case 'thunderstorm':
        return 'assets/animations/thunder.json';
      case 'clear':
        return 'assets/animations/sunny.json';
      default:
        return 'assets/animations/sunny.json';
    }
  }

  // Init State
  @override
  void initState() {
    super.initState();

    // Fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: updateBackgroundColor(),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // City name
              Container(
                child: Column(children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.grey.shade600,
                    size: 30,
                  ),
                  Text(
                    _weatherModel?.cityName ?? "Loading city...",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Oswald',
                        color: updateTextColor()),
                  ),
                ]),
              ),

              // Animation
              Lottie.asset(getWeatheranimation(_weatherModel?.mainCondition)),

              Container(
                child: Column(children: [
                  // Temperature
                  Text(
                    '${_weatherModel?.temperature.round()}°C',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Oswald',
                      color: updateTextColor(),
                    ),
                  ),
                  // Weather condition
                  Text(
                    _weatherModel?.mainCondition ?? "",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Oswald',
                        color: updateTextColor()),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
