import 'package:dio/dio.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WeatherService {
  final dio =
      Dio(BaseOptions(baseUrl: "https://api.openweathermap.org/data/2.5"));
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<WeatherModel> getWeather(String cityName) async {
    try {
      final response =
          await dio.get("/weather?q=$cityName&appid=$apiKey&units=metric");
      return WeatherModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();

    // Get permission from user
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high));

    // Convert the location into a list of placemark objects
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // Extract the city name from the first placemark
    String? city = placemarks[0].locality ?? "";

    return city;
  }
}
