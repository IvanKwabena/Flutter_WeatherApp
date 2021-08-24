import 'dart:convert';

import 'package:clima/services/location.dart';
import 'package:clima/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double latitude;
  double longitude;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    // Getting User Location
    Location location = Location();
    await location.getCurrentLocation();
    latitude = location.latitude;
    longitude = location.longitude;
    print(latitude);
    print(longitude);
    getData();
  }

  //Get Data from the Internet
  void getData() async {
    http.Response response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=5.6037&lon=-0.1870&appid=${WEATHER_API}'),
    );
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data); // the jason data to be decodede

      var temperature = decodedData['main']['temp'];
      var condition = decodedData['weather'][0]['description'];
      var cityName = decodedData['name'];

      print(temperature);
      print(condition);
      print(cityName);
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: Center(
        //   child: ElevatedButton(
        //     onPressed: () {
        //       //Get the current location
        //       getLocation();
        //     },
        //     child: Text('Get Location'),
        //   ),
        // ),
        );
  }
}
