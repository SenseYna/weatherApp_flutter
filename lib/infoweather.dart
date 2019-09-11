import 'dart:convert';
import 'package:http/http.dart' as http;

import 'infolocation.dart';

MyLocation locationInstance = MyLocation();
Weather weatherInstance = Weather();

initWeather() async {
  await locationInstance.getPos();
  await weatherInstance.fetchData(
      locationInstance.latitude, locationInstance.longitude);
}

class Info {
  String summary;
  num temperature;
  num uvIndex;
}

class Address {
  String busStop;
  String road;
  String suburb;
  String town;
  String state;

  fetchData(String lat, String lon) async {
    //Lấy dữ liệu thời tiết
    var resLinkToData = await http.get(getLinkToName(lat, lon));
    var data = json.decode(resLinkToData.body);
    this.busStop = data['address']['bus_stop'];
    this.road = data['address']['road'];
    this.suburb = data['address']['suburb'];
    this.town = data['address']['town'];
    this.state = data['address']['state'];
  }

  @override
  String toString() {
    String address = "";
    if (busStop != null) {
      address += "$busStop,";
    }
    if (road != null) {
      address += " đường $road,";
    }
    if (suburb != null) {
      address += " $suburb,";
    }
    if (town != null) {
      address += " $town,";
    }
    if (state != null) {
      address += " $state.";
    }
    return address;
  }
}

class Weather {
  Address displayName;
  String daySummary;
  Info curently;
  Info nextTime;
  List<double> temperatures;

  Weather() {
    displayName = new Address();
    curently = new Info();
    nextTime = new Info();
    this.temperatures = new List();
  }

  isEmpty() {
    return (temperatures.isEmpty);
  }

  _mapData(Map json) {
    daySummary = json['hourly']['summary'];

    curently.summary = json['currently']['summary'];
    curently.temperature = json['currently']['temperature'];
    curently.uvIndex = json['currently']['uvIndex'];

    num nextHour = DateTime.now().hour - 2 + 1;
    List data = json['hourly']['data'];

    nextTime.summary = data[nextHour]['summary'];
    nextTime.temperature = (data[nextHour]['temperature']);
    nextTime.uvIndex = data[nextHour]['uvIndex'];

    for (int i = 0; i < 24; i++) {
      temperatures.add(data[i]['temperature']);
    }
  }

  fetchData(String lat, String lon) async {
    //Lấy dữ liệu thời tiết
    var resLinkToData = await http.get(getLinkToData(lat, lon));
    var data = json.decode(resLinkToData.body);
    _mapData(data);
    //Lấy dữ liệu tên hiển thị
    await displayName.fetchData(lat, lon);
  }
}

String getLinkToData(String lat, String lon) {
  return 'https://api.darksky.net/forecast/2b2738440aec7eac2e38504667849eb5/$lat,$lon?exclude=daily,flags&lang=vi&units=si';
}

String getLinkToName(String lat, String lon) {
  return 'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$lat&lon=$lon';
}
