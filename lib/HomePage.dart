import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flutter/material.dart';
import 'package:weather_app_flutter/Map.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_app_flutter/Model/User_Info.dart';
import 'package:weather_app_flutter/Test.dart';
import './Home.dart';
import './Map.dart';
import './About.dart';
import './Chart.dart';
import './Post.dart';
import 'infoweather.dart';
import 'package:weather_app_flutter/Services/Authentication.dart';


class MyApp1 extends StatefulWidget {

  MyApp1({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;


  @override
  State<StatefulWidget> createState() {
    return _MyApp1State();
  }
}

class _MyApp1State extends State<MyApp1> {
  bool _isLoaded = false;

  initResource() async {
    await initWeather();
    _isLoaded = true;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initResource();
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoaded == true) {
      return new ChangeNotifierProvider(
        builder: (context)=>UserData(),
          child:MaterialApp(
        title: 'Now Temperature',
        theme: new ThemeData(primarySwatch: Colors.blue),
        home: new MyHomePage(title: 'Now Temperature',signOut: widget.logoutCallback,userId: widget.userId,),
      )
    );
    }
    return MaterialApp(
      home: Scaffold(
        body: Center(
         child: CircularProgressIndicator())
         
      ),
    );
  }
}

final key = new GlobalKey<_MyHomePageState>();

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
    PostPage(),
    ChartPage(),
    AboutPage(),
  ];

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  ActorAnimation _rock;

  Widget setPage(int _selectPage)
  {
    if(_selectPage!=4)
      return _pageOptions[_selectPage];
    else
      return AboutPage(auth: new Auth(),logoutCallback: widget.signOut,userID: widget.userId );

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
    Provider.of<UserData>(context).currentUserId=widget.userId;
    return new Scaffold(

      backgroundColor: Colors.grey,
      appBar: new AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo-eureka.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            Container(
                padding: const EdgeInsets.all(8.0), child: Text(widget.title))
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: setPage(_selectedPage),//_pageOptions[_selectedPage],
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
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartLine),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title,this.signOut,this.userId}) : super(key: key);
  final String title;
  final VoidCallback signOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _MyHomePageState();


}

