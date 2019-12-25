import 'package:flutter/material.dart';
import './Root_page.dart';
import 'package:weather_app_flutter/Services/Authentication.dart';

void main() {
  runApp(new Login());
  //runApp(MyApp1());
  // runApp(MyApp());
}

/*class MyApp1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp1State();
  }
}
*/
class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
        title: 'Flutter Login Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth()),
    );
  }
}

// void main() => runApp(new MyApp());

/*class MyApp extends StatelessWidget {
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
*/
