import 'dart:ffi';

import 'package:geolocator/geolocator.dart';

class Location {
  double longitude;
  double latitude;

  // ignore: missing_return
  Future<Void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }
}
