import 'package:geolocator/geolocator.dart';

class MyLocation {
  String _latitude;
  String _longitude;

  get latitude => _latitude;

  get longitude => _longitude;

  getPos() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      this._latitude = position.latitude.toString();
      this._longitude = position.longitude.toString();
    }
  }
}
