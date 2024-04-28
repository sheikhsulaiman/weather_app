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
  //network state
  bool _isNetworkError = false;

  //api key
  final _weatherService =
      WeatherService(apiKey: "b1031ff838064a29a61ecfbc4213d3c9");
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current city
    List<String> city = await _weatherService.getCurrentCity();

    // get the weather for the current city

    try {
      Weather weather = await _weatherService.getWeather(city[0], city[1]);

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        _isNetworkError = true;
      });
    }
  }

  // weather animation

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/animations/clear.json';
    }
    switch (mainCondition) {
      case 'Clear':
        return 'assets/animations/clear.json';
      case 'Clouds':
        return 'assets/animations/clouds.json';
      case 'Rain':
        return 'assets/animations/rain.json';
      case 'Snow':
        return 'assets/animations/snow.json';
      case 'Atmosphere':
        return 'assets/animations/atmosphere.json';
      case 'Thunderstorm':
        return 'assets/animations/thunderstorm.json';
      case 'Drizzle':
        return 'assets/animations/drizzle.json';

      default:
        return 'assets/animations/clear.json';
    }
  }

  // init state

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _weather != null ? const Icon(Icons.place) : null,
        title: Text('${_weather != null ? _weather?.cityName : "Weather Lite"}',
            style: const TextStyle(fontSize: 20)),
      ),
      body: Center(
        child: _isNetworkError
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/no_internet.png',
                      height: 200, width: 200),
                  const SizedBox(height: 20),
                  Text('An error occurred while fetching the weather',
                      style: TextStyle(
                        color: Colors.red[400],
                      )),
                  const SizedBox(height: 20),
                  // retry button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _isNetworkError = false;
                        });
                        _fetchWeather();
                      },
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ))
                ],
              )
            : _weather == null
                ? const CircularProgressIndicator()
                : SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            getWeatherAnimation(_weather!.mainCondition),
                            height: 200,
                            width: 200,
                          ),
                          Text(
                            '${_weather!.temperature}°C',
                            style: const TextStyle(fontSize: 30),
                          ),
                          Text(
                            _weather!.mainCondition,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ]),
                  ),
      ),
    );
  }
}
