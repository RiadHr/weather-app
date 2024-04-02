import 'package:geolocator/geolocator.dart';

class Location {

  Location({this.latitude, this.longitude});

  double latitude;
  double longitude;

  Future<void> getCurrentLocation() async {
    try{
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
      // print(position);
      // print('$longitude');
      // print('$latitude');
    }catch(e){
      print(e);
    }
  }

}