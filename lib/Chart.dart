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
  MyLocation _myLocation = new MyLocation();
  Weather _weather = new Weather();

  _generateData() async { 
    await _myLocation.getPos();
    await _weather.fetchData(_myLocation.latitude, _myLocation.longitude);
  
    List<Sales> datatemperature = new List();
    int j=0;
    for (int i = 0; i < 24; i+=1) {
      datatemperature.add(Sales(j++, _weather.infos[i].temperature));
      
    }

  //  var linesalesdata2 = [
  //     new Sales(0, 20),
  //     new Sales(1, 24),
  //     new Sales(2, 25),
  //     new Sales(3, 40),
  //     new Sales(4, 45),
  //     new Sales(5, 60),
  //   ];
    
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
   setState(() {

   });
  }

  @override
  void initState() {
    // TODO: implement initState
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
            color: Colors.white,
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(''),
                  Text(
                    'Biểu đồ nhiệt độ trong ngày',
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
