class WeatherModel {
  final String cityName;
  final double temperature;
  final String mainCondition;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });

  WeatherModel.fromJson(Map<String, dynamic> json)
      : cityName = json['name'],
        temperature = json['main']['temp'] as double,
        mainCondition = json['weather'][0]['main'];
}
