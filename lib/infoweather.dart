import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'infolocation.dart';
import 'weatherwidget.dart';

MyLocation locationInstance = MyLocation();
Weather weatherInstance = Weather();
Warning warningUV = Warning();
MyFlare myflare = new MyFlare();

initWeather() async {
  await locationInstance.getPos();
  await weatherInstance.fetchData(
      locationInstance.latitude, locationInstance.longitude);
  //myflare = new MyFlare();
}

class Warning {
  String textTitle;
  String textContent;
  Color color;
  BoxDecoration boxDecoration;

  Warning() {
    if (weatherInstance.curently.uvIndex > -1 &&
        weatherInstance.curently.uvIndex < 3) {
      textTitle = "\nCẢNH BÁO NGUY HIỂM THẤP";
      textContent = "(Bạn vẫn có thể an toàn khi ở ngoài trời.)";
      boxDecoration = BoxDecoration(
          border: Border.all(width: 2.0, color: Colors.white.withOpacity(0.5)));
      color = Colors.green;
    } else if (weatherInstance.curently.uvIndex < 6) {
      textTitle = "\nCẢNH BÁO RỦI RO VỪA PHẢI";
      textContent =
          "(Bạn nên sử dụng kem chống nắng, kính râm, che chắn cơ thể.)";
      boxDecoration = BoxDecoration(
          border: Border.all(width: 2.0, color: Colors.white.withOpacity(0.5)));
      color = Colors.yellow;
    } else if (weatherInstance.curently.uvIndex < 9) {
      textTitle = "CẢNH BÁO NGUY CƠ CAO";
      textContent =
          "(Bạn nên sử dụng kem chống nắng (SPF>15+), kính râm, che chắn cơ thể và tìm kiếm bóng râm. Giảm thiểu thời gian tiếp xúc ánh nắng.)";
      boxDecoration = BoxDecoration(boxShadow: [
        BoxShadow(blurRadius: 1.0, color: Colors.black.withOpacity(0.4))
      ]);

      color = Colors.orange;
    } else if (weatherInstance.curently.uvIndex < 11) {
      textTitle = "CẢNH BÁO NGUY CƠ CAO";
      textContent =
          "(Bạn nên sử dụng kem chống nắng (SPF>30), kính râm, che chắn cơ thể, chăm sóc da để tránh cháy nắng. Không nên đứng dưới nắng quá lâu lúc này.)";
      boxDecoration = BoxDecoration(boxShadow: [
        BoxShadow(blurRadius: 1.0, color: Colors.black.withOpacity(0.4))
      ]);
      color = Colors.red;
    } else {
      textTitle = "NGUY CƠ RẤT CAO";

      textContent =
          "(Bạn nên sử dụng kem chống nắng (SPF>30+), kính râm, che chắn cơ thể. Tránh tiếp xúc trực tiếp ánh nắng lúc này.)";
      boxDecoration = BoxDecoration(
          color: Colors.red.withOpacity(0.8),
          boxShadow: [BoxShadow(blurRadius: 1.0, color: Colors.grey[400])]);
      color = Colors.purple;
    }
  }
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
    if (town != null) {
      address += "$town";
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
      temperatures.add(data[i]['temperature'] * 1.0);
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
