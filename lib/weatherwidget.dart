import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'infolocation.dart';
import 'infoweather.dart';
import 'speakdata.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';

bool isPausedd = false;
bool onVoice = true;
_MyFlareState example;

class MyFlare extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    example = new _MyFlareState();
    return example;
  }
}

class _MyFlareState extends State<MyFlare> {
  bool _isPaused = isPausedd;
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: FlareActor(
        "assets/Penguin.flr",
        alignment: Alignment.bottomCenter,
        isPaused: _isPaused,
        fit: BoxFit.cover,
        animation: "walk",
      ),
    );
  }

  void pauseFlare() {
    _isPaused = !_isPaused;
    setState(() {});
  }
}

// MyFlare myflare = new MyFlare();

class WeatherWidget extends StatefulWidget {
  WeatherWidget({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  Weather _weather = new Weather();
  Speaker _speaker = Speaker();
  String text;
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
    text =
        "Xin chào, bây giờ là ${DateTime.now().hour} giờ ${DateTime.now().minute} phút. Nhiệt độ ngoài trời hiện tại là: ${_weather.curently.temperature..toStringAsFixed(0)} °C. Chỉ số tia cực tím là: ${_weather.curently.uvIndex.toString()}. Đang ở mức: ${ warningUV.textTitle} ${warningUV.textContent}. Chúc bạn có một ngày tốt lành.";
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
            child: Column(
              // column location + temperature
              children: <Widget>[
                Row(
                  // row location + icon + temperature
                  children: <Widget>[
                    Column(
                      // column location + temperature
                      children: <Widget>[
                        Row(
                          //row temperature
                          children: <Widget>[
                            Text(" ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 50),
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 45),
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
                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                          width: 120.0,
                          height: 15.0,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                    "📍" + _weather.displayName.toString(),
                                    style: TextStyle(
                                        color: Colors.grey[300], fontSize: 15),
                                    textAlign: TextAlign.left),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      //column icon
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                          width: 70.0,
                          height: 40.0,
                          child: Column(
                            children: <Widget>[
                              Icon(
                                setIconKind(timeNow),
                                color: Colors.yellow[300],
                                size: 40.0,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 0.0),
                          padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                          width: 118.0,
                          height: 94.0,
                          child: Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text('\n\n\n\nChỉ số UV: ',
                                      style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 10),
                                      textAlign: TextAlign.right),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 65.0,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 1.0,
                                            color:
                                                Colors.black.withOpacity(0.04))
                                      ],
                                    ),
                                    // margin:
                                    //     EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
                                    child: Text(
                                        _weather.curently.uvIndex.toString(),
                                        style: TextStyle(
                                            letterSpacing: -8.0,
                                            color: warningUV.color,
                                            fontSize: 64),
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  // row location + icon + temperature
                  children: <Widget>[
                    Container(
                      height: 110.0,
                      width: 290.0,
                      decoration: warningUV.boxDecoration,
                      child: Column(
                        // row location + icon + temperature
                        children: <Widget>[
                          Text(''),
                          Text(
                            warningUV.textTitle,
                            style: TextStyle(
                                fontSize: 18.0,
                                color: warningUV.color,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            warningUV.textContent,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: warningUV.color,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //Text(""),
          
          Container(
            width: 320.0,
            height: 70.0,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(blurRadius: 2.0, color: Colors.black.withOpacity(0.07))
              ],
            ),
            padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
            margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                  child: Text(
                    "Dự báo trong ngày ",
                    style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  width: 2.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(width: 1.0, color: Colors.grey[300]),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 60.0,        
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                    child: Text(_weather.daySummary.toString(),
                        style: TextStyle(color: Colors.grey[50], fontSize: 16),
                        textAlign: TextAlign.justify),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(94.0, 10.0, 90.0, 10.0),
                padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                height: 106.0,
                width: 106.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(53.0),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2.0,
                        color: Colors.grey[300].withOpacity(0.8))
                  ],
                  color: voiceColor(onVoice),
               
                ),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        height: 96.0,
                        width: 96.0,
                        child: Row(
                          children: <Widget>[
                            
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(48.0),
                            color: Colors.transparent,
                            
                            image: DecorationImage(image: voiceImage(onVoice))),
                      ),
                      onTap: setVoiceStatus,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }
    return Text("Đang lấy dữ liệu....",
        style: TextStyle(color: Colors.white, fontSize: 20));
  }

  void setVoiceStatus() {
    if (!onVoice)
      _speaker.speak(text); //(setVoiceStatus);
    else
      _speaker.top();
    onVoice = !onVoice;

    isPausedd = !isPausedd;
    example.pauseFlare();
    setState(() {});
  }
}

AssetImage voiceImage(bool on) {
  if (on) return AssetImage('assets/images/voice_on.png');
  return AssetImage('assets/images/voice_off.png');
}

Color voiceColor(bool on) {
  if (on) return Colors.grey[400].withOpacity(0.9);
  return Colors.grey[800].withOpacity(0.9);
}

IconData setIconKind(int timeNow) {
  if (timeNow > 6 && timeNow < 18) {
    return FontAwesomeIcons.cloudSun;
  } else {
    return FontAwesomeIcons.cloudMoon;
  }
}
