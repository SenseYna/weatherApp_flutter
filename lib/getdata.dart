import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:geolocator/geolocator.dart';

class Info extends StatefulWidget {
  Info({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InfoState();
}

MyData _myData = MyData();

class _InfoState extends State<Info> {
  // var myData;
  // MyData get myData {
  //   if (_myData == null) {
  //     _myData = MyData(); // Instantiate the object if its null.
  //   }
  //   return _myData;
  // }

  Geolocator geolocator = new Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  _getPos() {
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      if (position != null) {
        setState(() {
        _myData.lat = position.latitude.toString();
        _myData.lon = position.longitude.toString();
        });
        _getData();
      } else {
        setState(() {
          _myData.error = true;
        });
      }
    });
  }

  _getData() {
    API
        .getData(
            'https://api.darksky.net/forecast/2b2738440aec7eac2e38504667849eb5/${_myData.lat},${_myData.lon}')
        .then((response) {
      var data = json.decode(response.body);
      setState(() {
        _myData = MyData.fromJson(data);
      });
    });
    API
        .getData(
            'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${_myData.lat}&lon=${_myData.lon}')
        .then((response) {
      var data = json.decode(response.body);
      setState(() {
        _myData.displayName = data['display_name'];
      });
    });
  }

  initState() {
    super.initState();
    _getPos();
  }

  dispose() {
    super.dispose();
  }

  @override
  build(context) {
    if (_myData.error) {
      return Text("Lỗi!!!");
    } else if (_myData.displayName != null &&
        _myData.temperature != null &&
        _myData.uvIndex != null) {
      return Column(
        children: <Widget>[
          Text("VỊ TRÍ: " + _myData.displayName.toString(),
              style: TextStyle(color: Colors.white, fontSize: 20)),
          Text("NHIỆT ĐỘ: " + _myData.temperature.toStringAsFixed(2) + "°C",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          Text("UV: " + _myData.uvIndex.toString(),
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ],
      );
    }
    return Text("Đang lấy dữ liệu....",
        style: TextStyle(color: Colors.white, fontSize: 20));
  }
}

class API {
  static Future getData(String url) {
    return http.get(url);
  }
}

class MyData {
  String _lat;

  String get lat => _lat;

  set lat(String lat) {
    _lat = lat;
  }

  String _lon;

  String get lon => _lon;

  set lon(String lon) {
    _lon = lon;
  }

  num _temperature;

  num get temperature => _temperature;

  set temperature(num temperature) {
    _temperature = temperature;
  }

  num _uvIndex;

  num get uvIndex => _uvIndex;

  set uvIndex(num uvIndex) {
    _uvIndex = uvIndex;
  }

  String _displayName;

  String get displayName => _displayName;

  set displayName(String displayName) {
    _displayName = displayName;
  }

  bool _error = false;

  bool get error => _error;

  set error(bool error) {
    _error = error;
  }

  MyData();

  MyData.fromJson(Map json)
      : _temperature = ((json['currently']['temperature'] - 32) * 5 / 9),
        _uvIndex = json['currently']['uvIndex'];

  Map toJson() {
    return {
      'temperature': temperature,
      'uvIndex': uvIndex,
      'displayName': displayName
    };
  }
}
