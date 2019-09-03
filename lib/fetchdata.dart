import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:geolocator/geolocator.dart';

import 'speakdata.dart';

class Info extends StatefulWidget {
  Info({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InfoState();
}

MyData _myData = MyData();
Speaker speaker = Speaker();
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
    speaker.top();
    super.dispose();
  }

  @override
  build(context) {
    if (_myData.error) {
      return Text("Lỗi!!!");
    } else if (_myData.displayName != null &&
        _myData.temperature != null &&
        _myData.uvIndex != null) {
          String text = "Xin chào Minh, Vị trí hiện tại của bạn là ${_myData.displayName.toString()}. Nhiệt độ hiện tại là ${_myData.temperature.toStringAsFixed(2)} °C, chỉ số tia cực tím là: ${_myData.uvIndex.toString()}. Khoảng 1 giờ sau, Nhiệt độ sẽ thay đổi: ${_myData.nextTemperature.toStringAsFixed(2)} °C với chỉ số tia cực tím là ${_myData.nextuvIndex.toString()}. Chúc bạn sắp xếp được khoảng thời gian ra ngoài hợp lý.";
          speaker.speak(text);
      return ListBody(children: <Widget>[        
          Text("Vị trí: " + _myData.displayName.toString(),
              style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.left),
          Text("Nhiệt độ: " + _myData.temperature.toStringAsFixed(2) + "°C",
              style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.left),
          Text("Tia uv: " + _myData.uvIndex.toString(),
              style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.left),
          Text(""),
          Text("Dự đoán 1 giờ sau:",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
          Text("Nhiệt độ: " + _myData.nextTemperature.toStringAsFixed(2) + "°C",
              style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.left),
          Text("Tia uv: " + _myData.nextuvIndex.toString(),
              style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.left),
      ],);

      
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

  num _nextTemperature;

  num get nextTemperature => _nextTemperature;

  set nextTemperature(num nextTemperature) {
    _nextTemperature = nextTemperature;
  }

  num _nextuvIndex;

  num get nextuvIndex => _nextuvIndex;

  set nextuvIndex(num nextuvIndex) {
    _nextuvIndex = nextuvIndex;
  }

  MyData();

  MyData.fromJson(Map json)
      : _temperature = ((json['currently']['temperature'] - 32) * 5 / 9),
        _uvIndex = json['currently']['uvIndex'],
        _nextTemperature =
            ((json['hourly']['data'][0]['temperature'] - 32) * 5 / 9),
        _nextuvIndex = json['hourly']['data'][0]['uvIndex'];

  Map toJson() {
    return {
      'temperature': temperature,
      'uvIndex': uvIndex,
      'displayName': displayName
    };
  }
}
