import 'package:clima/screens/city_screen.dart';
import 'package:clima/screens/error_page.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';

class LocationScreen extends StatefulWidget {
  final weatherData;
  LocationScreen(this.weatherData);
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String bgImage;
  String weatherDescription;
  int temperature;
  String weatherMessage;
  String weatherIcon;
  String cityName;
  WeatherModel weatherModel = WeatherModel();

  @override
  void initState() {
    super.initState();
    updateUI(widget.weatherData);
  }

  void updateUI(dynamic data) {
    setState(() {
      try {
        double temp = data['main']['temp'];
        temperature = temp.round();
        var condition = data['weather'][0]['id'];
        weatherIcon = weatherModel.getWeatherIcon(condition);
        cityName = data['name'];
        weatherMessage = weatherModel.getMessage(temperature);
        weatherDescription = data['weather'][0]['description'];
        print(weatherDescription);
      } catch (e) {
        if (data == 401 || data == null) {
          // temperature = 0;
          // weatherIcon = 'Error';
          // weatherMessage = 'Something';
          // cityName = ' ';
          // print('error');

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ErrorPage()));
        }
      }
    });
  }

  // void alertMessage() {
  //   Alert(
  //     context: context,
  //     title: 'ERROR!',
  //     desc: 'NO CONNECTION',
  //   ).show();
  // }
  //  (weatherDescription == 'broken clouds' ||
  //     weatherDescription == 'shower rain' ||
  //     weatherDescription == 'light rain' ||
  //     weatherDescription == 'thunderstorm')

  @override
  Widget build(BuildContext context) {
    var checkRain = weatherDescription.toLowerCase().contains('rain');
    var checkClouds = weatherDescription.toLowerCase().contains('cloud');
// var checkRain = weatherDescription.toLowerCase().contains('clouds');

    if (weatherDescription == 'clear sky') {
      bgImage = 'images/sunny.jpg';
    } else if (checkClouds == true) {
      print(checkClouds);
      bgImage = 'images/cloudy.jpeg';
    } else if (checkRain == true) {
      bgImage = 'images/rainy.jpg';
    } else {
      bgImage = 'images/night.jpeg';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          splashRadius: 20.0,
          padding: EdgeInsets.only(left: 20.0, top: 20.0),
          onPressed: () async {
            var weatherLocationData = await weatherModel.getWeatherLocation();
            updateUI(weatherLocationData);
          },
          icon: Icon(
            Icons.navigation_rounded,
            size: 40,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              padding: EdgeInsets.only(right: 40.0, top: 20.0),
              onPressed: () async {
                // Receiving data backwards
                var typedName = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CityScreen(),
                  ),
                );
                if (typedName != null) {
                  var weatherData =
                      await weatherModel.getCityWeather(typedName);
                  updateUI(weatherData);
                }
              },
              icon: Icon(
                Icons.location_city,
                color: Colors.white,
                size: 40.0,
              ))
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bgImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.7), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "${weatherMessage} in ${cityName}!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
