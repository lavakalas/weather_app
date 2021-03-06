import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/pages/geo_page.dart';

import 'package:weather_app/pages/home_page.dart';
import 'package:weather_app/pages/loading_page.dart';
import 'package:weather_app/weather.dart';
import 'package:weather_app/weather_repository.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  Weather weather = Weather();
  weatherRepository WR = weatherRepository();

  void loading() async {
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    num lon = position.longitude;
    num lat = position.latitude;
    await WR.getWeather(lat, lon);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    loading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,]);
    return MaterialApp(
      title: "Weathery",
      color: Colors.blueAccent,
      home: isLoading
          ? LoadingPage()
          : HomePage(
              weather: WR.decodedData,
            ),
      routes: {
        '/home': ((BuildContext context) => HomePage()),
        '/loading': ((BuildContext context) => LoadingPage()),
        '/error': ((BuildContext context) => GeoPage())
      },
    );
  }
}
