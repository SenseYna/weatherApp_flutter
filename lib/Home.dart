import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

// import 'fetchdata.dart';
// import 'getdata.dart';
import 'weatherwidget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    bool _isPaused = false;

    return new Stack(
        children: [
          Positioned.fill(
              child: FlareActor("assets/Penguin.flr",
                  alignment: Alignment.center,
                  isPaused: _isPaused,
                  fit: BoxFit.cover,
                  animation: "walk",
                  )),
          Positioned.fill(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Container(
                      padding: EdgeInsets.fromLTRB(5, 30, 5, 30),
                      height: 500,
                      width: 300,
                      decoration: new BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0),
                            bottomLeft: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0)),
                      ),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                           WeatherWidget()
                        ],
                      )),
                )
              ])),
        ],
      );
  }
}