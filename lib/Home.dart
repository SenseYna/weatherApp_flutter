import 'package:flutter/material.dart';
import 'weatherwidget.dart';
import 'infoweather.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    isPausedd = false;
    onVoice = true;
    return new Stack(
      children: [
        myflare,
        Positioned.fill(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Container(
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                    height: 500,
                    width: 300,
                    decoration: new BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0),
                          bottomLeft: const Radius.circular(20.0),
                          bottomRight: const Radius.circular(20.0)),
                    ),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[WeatherWidget()],
                    )),
              )
            ])),
        Container(
          margin: EdgeInsets.fromLTRB(0.0, 550.0, 0.0, 0.0),
          child: Column(
            children: <Widget>[
              Text('Dữ liệu được cung cấp một phần bởi ',
                  style: TextStyle(color: Colors.black, fontSize: 8),
                  textAlign: TextAlign.left),
              Container(
                height: 10.0,
                //width: 10.0,
                decoration: BoxDecoration(

                    // image: DecorationImage(image: NetworkImage(image))),
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo-darksky.png'),
                        fit: BoxFit.fitHeight)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
