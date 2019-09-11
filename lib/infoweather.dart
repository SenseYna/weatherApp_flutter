import 'dart:convert';
import 'package:http/http.dart' as http;

String getLinkToData(String lat, String lon){
  return  'https://api.darksky.net/forecast/2b2738440aec7eac2e38504667849eb5/$lat,$lon?exclude=daily,flags&lang=vi';
}
String getLinkToName(String lat, String lon){
  return  'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$lat&lon=$lon';
}

class Info {
  String summary;
  num temperature;
  num uvIndex;
}

class Weather {
  String displayName;
  Info curently;
  List<Info> infos;
  
  Weather() {
    curently = new Info();
    this.infos = new List();
  }

  _mapData(Map json)
  {
    curently.summary = json['currently']['summary'];
    curently.temperature = (json['currently']['temperature'] - 32) * 5 / 9;
    curently.uvIndex = json['currently']['uvIndex'];
    
    List data = json['hourly']['data'];
    for(int i = 0; i < 24; i++){
    Info temp = Info();
      temp.summary = data[i]['summary'];
     // temp.temperature = (data[i]['temperature']);
      temp.temperature = (data[i]['temperature'] - 32) * 5 / 9;
      temp.uvIndex = data[i]['uvIndex'];
      infos.add(temp);
    }
  }

fetchData(String lat, String lon) async {
    //Lấy dữ liệu thời tiết
    var resLinkToData = await http.get(getLinkToData(lat, lon));
    var data = json.decode(resLinkToData.body);
    _mapData(data);
    //Lấy dữ liệu tên hiển thị
    var resLinkToName = await http.get(getLinkToName(lat, lon));
    var name = json.decode(resLinkToName.body);
    this.displayName = name['display_name']; 
  }
}

