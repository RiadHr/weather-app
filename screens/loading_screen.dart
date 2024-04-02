import 'package:clima/screens/location_screen.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/networking.dart';

var apiKey = '33e07c067eba08a8848bfaebd468f1e2';
var longitude;
var latitude;

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationData();
    getLocation();
  }

  void getData() async {
  var url = Uri.http('api.openweathermap.org/geo/1.0/direct?q=London&limit=5&appid=33e07c067eba08a8848bfaebd468f1e2',);
  http.Response response = await http.get(Uri(scheme: 'https',host: 'api.openweathermap.org',path: '/geo/1.0/direct?q=Alger&limit=5&appid=33e07c067eba08a8848bfaebd468f1e2'));
  url = Uri.http('api.openweathermap.org','/geo/1.0/direct?q=Alger&limit=5&appid=33e07c067eba08a8848bfaebd468f1e2');
  response = await http.get(
    Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey'),
  );

  if (response.statusCode == 200) {
    String res = response.body;
    print(response.body);

  var longitude = jsonDecode(res)[1]['lon'];
  var latitude = jsonDecode(res)[1]['lat'];
  var localName = jsonDecode(res)[2]['local_names']['ascii'];
  print('longitude = $longitude' );
  print( 'latitude = $latitude');
  print('local = $localName');

    var name = jsonDecode(res)[0]['name'];
    print(name);
    } else {
      print(response.statusCode);
    }
  }

  void getLocationData() async {
    Location location = Location();
    await location.getCurrentLocation();

    latitude = location.latitude;
    longitude = location.longitude;

    Uri url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');

    NetworkHelper networkHelper = NetworkHelper(url: url);
    var weatherData = await networkHelper.getData();
    print(weatherData);
    WeatherModel weatherModel = WeatherModel();
    weatherData =await weatherModel.getLocationWeather();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LocationScreen(
            weatherData: weatherData,
          );
        },
      ),
    );

    // print(location.longitude);
    // print(location.latitude);
  }

  void getLocation () async {

      LocationPermission permission;
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          return Future.error('Location Not Available');
        }
      } else {
        throw Exception('Error');
      }
      try{
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        print(position);
      }catch(e){
        print(e);
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SpinKitDoubleBounce(
        color: Colors.blue.shade300,
        size: 100,
      ),
    );
  }
}
