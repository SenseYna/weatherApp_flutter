import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'infolocation.dart';
import 'infoweather.dart';
import 'speakdata.dart';

class WeatherWidget extends StatefulWidget {
  WeatherWidget({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  Weather _weather = new Weather();
  Speaker _speaker = Speaker();

  _init() async {
    if (!weatherInstance.isEmpty()) {
      _weather = weatherInstance;
    } else {
      MyLocation _myLocation = new MyLocation();
      locationInstance = _myLocation;
      await _myLocation.getPos();
      await _weather.fetchData(_myLocation.latitude, _myLocation.longitude);
    }
    weatherInstance = _weather;
    setState(() {
      _weather = _weather;
    });
    String text =
        "Xin chào bạn, bây giờ là ${DateTime.now().hour} giờ ${DateTime.now().minute} phút. Nhiệt độ ngoài trời hiện tại là: ${_weather.curently.temperature.toString()} °C. Chỉ số tia cực tím là: ${_weather.curently.uvIndex.toString()}. Dự báo thời tiết trong một giờ tới là: ${_weather.nextTime.summary.toString()}. Chúc bạn có một ngày tốt lành.";
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

  var timeNow = DateTime.now().hour;
  @override
  build(context) {
    if (_weather == null) {
      return Text("Lỗi!!!");
    } else if (_weather.displayName != null &&
        _weather.curently.temperature != null &&
        _weather.curently.uvIndex != null) {
      return ListBody(
        children: <Widget>[
          Container(
            //head
            child: Row(
              // row location + icon + temperature
              children: <Widget>[
                Column(
                  // column location + temperature
                  children: <Widget>[
                    Row(
                      //row temperature
                      children: <Widget>[
                        Text(" ",
                            style: TextStyle(color: Colors.white, fontSize: 50),
                            textAlign: TextAlign.left),
                        Column(
                          children: <Widget>[
                            Text(
                                _weather.curently.temperature
                                    .toStringAsFixed(0),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 100),
                                textAlign: TextAlign.left),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              '',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 45),
                            ),
                            Text("°C",
                                style: TextStyle(
                                    color: Colors.grey[200], fontSize: 15),
                                textAlign: TextAlign.left),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      // container location
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      width: 120.0,
                      height: 100.0,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                                "📍" + _weather.displayName.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                                textAlign: TextAlign.left),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 40,
                ),
                Column(
                  //column icon
                  children: <Widget>[
                    Container(
                      width: 70.0,
                      height: 30.0,
                      child: Column(
                        children: <Widget>[
                          Icon(
                            setIcon(timeNow),
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
                      width: 100.0,
                      height: 110.0,
                      child: Row(
                        children: <Widget>[
                          Text('\n\n\n\nChỉ số UV: ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                              textAlign: TextAlign.left),
                          Text(_weather.curently.uvIndex.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 84),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200.0,
          ),
          Text(
              "Nhiệt độ: " +
                  _weather.curently.temperature.toStringAsFixed(2) +
                  "°C",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.left),
          Text("Chỉ số tia cực tím: " + _weather.curently.uvIndex.toString(),
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.left),
          Text("Dự báo trong ngày: " + _weather.daySummary.toString(),
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.left),
          Text(""),
          Row(
            children: <Widget>[
              Container(
                height: 80,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 80.0,
              ),
              Text("Dự đoán 1 giờ sau:",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 80.0,
              ),
              Text(
                  "Nhiệt độ: " +
                      _weather.nextTime.temperature.toStringAsFixed(2) +
                      "°C",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.left),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 80.0,
              ),
              Expanded(
                child: Text("Dự báo: " + _weather.nextTime.summary.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.left),
              ),
            ],
          ),
        ],
      );
    }
    return Text("Đang lấy dữ liệu....",
        style: TextStyle(color: Colors.white, fontSize: 20));
  }
}

IconData setIcon(int timeNow) {
  if (timeNow > 6 && timeNow < 18) {
    return FontAwesomeIcons.cloudSun;
  } else {
    return FontAwesomeIcons.cloudMoon;
  }
}
