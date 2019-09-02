import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flutter/material.dart';
import './Home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Weather App UIT',
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new MyHomePage(title: 'Weather App UIT'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with FlareController {
  double _rockAmount = 0.5;
  double _speed = 1.0;
  double _rockTime = 0.0;
  bool _isPaused = false;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
   
    Text(
      'Index 1: Map',
      style: optionStyle,
    ),
    Text(
      'Index 2: About',
      style: optionStyle,
    ),
  ];

  ActorAnimation _rock;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
      appBar: new AppBar(title: new Text(widget.title)),
     
      // body: new Stack(
      //   children: [
      //     Positioned.fill(
      //         child: FlareActor("assets/Penguin.flr",
      //             alignment: Alignment.custom,
      //             isPaused: _isPaused,
      //             fit: BoxFit.cover,
      //             animation: "walk",
      //             controller: this)),
      //     Positioned.fill(
      //         child: new Column(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             children: <Widget>[
      //           Container(
      //             padding: EdgeInsets.fromLTRB(30, 40, 0, 0),
      //             child: Container(
      //                 padding: EdgeInsets.fromLTRB(20, 30, 0, 30),
      //                 height: 250,
      //                 width: 300,
      //                 decoration: new BoxDecoration(
      //                   color: Colors.black.withOpacity(0.5),
      //                   borderRadius: new BorderRadius.only(
      //                       topLeft: const Radius.circular(40.0),
      //                       topRight: const Radius.circular(40.0),
      //                       bottomLeft: const Radius.circular(40.0),
      //                       bottomRight: const Radius.circular(40.0)),
      //                 ),
      //                 child: new Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: <Widget>[
      //                     new Text("Hello",
      //                         style: TextStyle(color: Colors.white, fontSize: 20)
                              
      //                         ),
      //                   ],
      //                 )),
      //           )
      //         ])),
      //     // Positioned.fill(
      //     //     child: new Column(
      //     //         mainAxisAlignment: MainAxisAlignment.end,
      //     //         children: <Widget>[
      //     //       Container(
      //     //           height: 200,
      //     //           color: Colors.black.withOpacity(0.5),
      //     //           child: new Column(
      //     //             crossAxisAlignment: CrossAxisAlignment.start,
      //     //           )),
      //     //     ]))
      //   ],
      // ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Map'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            title: Text('About'),
          ),
        ],
         currentIndex: _selectedIndex,
         selectedItemColor: Colors.amber[800],
         onTap: _onItemTapped,
      ),
    );
  }
}
