import 'package:flutter/material.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:weather_app/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: lightMode,
      darkTheme: darkMode,
      home: const WeatherPage(),
    );
  }
}
