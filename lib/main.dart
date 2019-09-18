import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flutter/material.dart';
import 'package:weather_app_flutter/Map.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './Home.dart';
import './Map.dart';
import './About.dart';
import './Chart.dart';

void main() {
 // runApp(MyApp1());
  runApp(MyApp());
}

// class MyApp1 extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _MyApp1State();
//   }
// }

// class _MyApp1State extends State<MyApp1> {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return MaterialApp(
      
//      home: Scaffold(
//       body: Center(
//         child: Column(
//           //mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//                 margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//                 height: 590.0,
//                 width: 600.0,
//                 decoration: BoxDecoration(

//                     // image: DecorationImage(image: NetworkImage(image))),
//                     image: DecorationImage(
//                         image: AssetImage('assets/images/cloud1.jpg')))),
//           ],
//         ),
//       ),
//     ),
        

//     );
//   }
// }





class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Weather App',
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new MyHomePage(title: 'Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with FlareController {
  double _rockAmount = 0.5;
  double _speed = 1.0;
  double _rockTime = 0.0;

  // https://www.youtube.com/watch?v=n_FRmFm9Tyw
  int _selectedPage = 0;
  final List<charts.Series> seriesList = [];
  final bool animate = true;

  final _pageOptions = [
    HomePage(),
    MapPage(),
    ChartPage(),
    AboutPage(),
  ];

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  ActorAnimation _rock;

  @override
  void initialize(FlutterActorArtboard artboard) {
    _rock = artboard.getAnimation("music_walk");
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    _rockTime += elapsed * _speed;
    _rock.apply(_rockTime % _rock.duration, artboard, _rockAmount);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey,
      appBar: new AppBar(
        title: new Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Map'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartLine),
            title: Text('Chart'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            title: Text('About'),
          ),
        ],
      ),
    );
  }
}
