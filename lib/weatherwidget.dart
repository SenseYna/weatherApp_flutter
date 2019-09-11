
import 'package:flutter/material.dart';

import 'infolocation.dart';
import 'infoweather.dart';
import 'speakdata.dart';

class WeatherWidget extends StatefulWidget {
  WeatherWidget({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  MyLocation _myLocation = MyLocation();
  Weather _weather = Weather();
  Speaker _speaker = Speaker();

  _init() async {
    await _myLocation.getPos();
    await _weather.fetchData(_myLocation.latitude, _myLocation.longitude);
    setState(() {
      _weather = _weather;
    });

    String text = "Chào buổi sáng, thông tin thời tiết hôm nay dành cho bạn như sau: Nhiệt độ hiện tại là ${_weather.curently.temperature.toStringAsFixed(2)} °C, chỉ số tia cực tím là: ${_weather.curently.uvIndex.toString()}. vị trí hiện tại của bạn là ${_weather.displayName.toString()}. Hi vọng bạn sắp xếp được khoảng thời gian ra ngoài hợp lý.";
    _speaker.speak(text);
  }
  initState() {
    _init();
    super.initState();
  }

  dispose() {
    _speaker.top();
    super.dispose();
  }

  @override
  build(context) {
    if (_weather == null) {
      return Text("Lỗi!!!");
    } else if (_weather.displayName != null &&
        _weather.curently.temperature != null &&
        _weather.curently.uvIndex != null) {
       return ListBody(
        children: <Widget>[
          Text("Vị trí: " + _weather.displayName.toString(),
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.left),
          Text("Nhiệt độ: " + _weather.curently.temperature.toStringAsFixed(2) + "°C",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.left),
          Text("Tia uv: " + _weather.curently.uvIndex.toString(),
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.left),
          // Text(""),
          // Text("Dự đoán 1 giờ sau:",
          //     style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 16,
          //         fontWeight: FontWeight.bold),
          //     textAlign: TextAlign.left),
          // Text("Nhiệt độ: " + _myData.nextTemperature.toStringAsFixed(2) + "°C",
          //     style: TextStyle(color: Colors.white, fontSize: 16),
          //     textAlign: TextAlign.left),
          // Text("Tia uv: " + _myData.nextuvIndex.toString(),
          //     style: TextStyle(color: Colors.white, fontSize: 16),
          //     textAlign: TextAlign.left),
        ],
      );
    }
    return Text("Đang lấy dữ liệu....",
        style: TextStyle(color: Colors.white, fontSize: 20));
  }
}
