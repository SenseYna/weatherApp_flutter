import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'infolocation.dart';
import 'infoweather.dart';

class ChartPage extends StatefulWidget {
  final Widget child;

  ChartPage({Key key, this.child}) : super(key: key);

  _TestState createState() => _TestState();
}

class _TestState extends State<ChartPage> {
  List<charts.Series<Sales, int>> _seriesLineData;
  MyLocation _myLocation = new MyLocation();
  Weather _weather = new Weather();

  _generateData() async {
    await _myLocation.getPos();

    var getWeather = await _weather.fetchData(_myLocation.latitude, _myLocation.longitude);
    print(
          _weather.infos[2].temperature.toString() + ' Test' );
    List<Sales> datatemperature = new List();
    datatemperature.add(Sales(0, 0));
    for (int i = 0; i < 24; i++) {
      print(
          getWeather[i].temperature.toString() + ' Chart' + (i.toString()));
    }
    // datatemperature.add(Sales(i+1, _weather.infos[i].temperature));

    // _seriesLineData.add(
    //   charts.Series(
    //     colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
    //     id: 'Air Pollution',
    //     data: linesalesdata,
    //     domainFn: (Sales sales, _) => sales.yearval,
    //     measureFn: (Sales sales, _) => sales.salesval,
    //   ),
    // );
    // _seriesLineData.add(
    //   charts.Series(
    //     colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
    //     id: 'Air Pollution',
    //     data: linesalesdata1,
    //     domainFn: (Sales sales, _) => sales.yearval,
    //     measureFn: (Sales sales, _) => sales.salesval,
    //   ),
    // );

    _seriesLineData = List<charts.Series<Sales, int>>();
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
        id: 'Air Pollution',
        data: datatemperature,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    setState(() {
      _seriesLineData = _seriesLineData;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _generateData();
  }

  Widget build(BuildContext context) {
    return new Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(0.0),
          child: Container(
            color: Colors.white,
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(''),
                  Text(
                    'Dự báo nhiệt độ trong ngày',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  Text(''),
                  Expanded(
                    child: charts.LineChart(_seriesLineData,
                        defaultRenderer: new charts.LineRendererConfig(
                            includeArea: false, //hightlight Area
                            stacked: true),
                        animate: true,
                        animationDuration: Duration(seconds: 2),
                        behaviors: [
                          new charts.ChartTitle('Giờ',
                              behaviorPosition: charts.BehaviorPosition.bottom,
                              titleOutsideJustification:
                                  charts.OutsideJustification.middleDrawArea),
                          new charts.ChartTitle('°C',
                              behaviorPosition: charts.BehaviorPosition.start,
                              titleOutsideJustification:
                                  charts.OutsideJustification.middleDrawArea),
                          new charts.ChartTitle(
                            '',
                            behaviorPosition: charts.BehaviorPosition.end,
                            titleOutsideJustification:
                                charts.OutsideJustification.middleDrawArea,
                          )
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Sales {
  int yearval;
  double salesval;

  Sales(this.yearval, this.salesval);
}
