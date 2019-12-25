import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'infolocation.dart';
import 'infoweather.dart';

class ChartPage extends StatefulWidget {
  final Widget child;

  ChartPage({Key key, this.child}) : super(key: key);

  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<charts.Series<Sales, int>> _seriesLineData;
  Weather _weather;


  _generateData() async {
    if (!weatherInstance.isEmpty()) {
      _weather = weatherInstance;
    } else {
      MyLocation _myLocation = new MyLocation();
      await _myLocation.getPos();
      await _weather.fetchData(_myLocation.latitude, _myLocation.longitude);
    }
    weatherInstance = _weather;
    List<Sales> datatemperature = new List();

    for (int i = 1; i < 24; i++) {
      datatemperature.add(Sales(i, _weather.temperatures[i]));
    }

    _seriesLineData = List<charts.Series<Sales, int>>();
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
        id: 'Air Pollution',
        //data: datatemperature,
        data: datatemperature,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _seriesLineData = List<charts.Series<Sales, int>>();
    _generateData();
  }

  Widget build(BuildContext context) {
    return new Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(0.0),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color.fromARGB(255, 132, 56, 207), Color.fromARGB(255, 157, 229, 244)])), // if current it
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(''),
                  Text(
                    'Biểu đồ nhiệt độ trong 24 giờ tới',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold,color: Colors.white),
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
                              behaviorPosition: charts.BehaviorPosition.top,
                              titleOutsideJustification:
                                  charts.OutsideJustification.start),
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
