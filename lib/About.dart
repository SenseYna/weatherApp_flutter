import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.white,
            height: 800,
            width: 800,
          ),
        ),
        Positioned.fill(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                    height: 500,
                    width: 300,
                    decoration: new BoxDecoration(
                      //image: DecorationImage(image: AssetImage('images/a.png')),
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(40.0),
                          topRight: const Radius.circular(40.0),
                          bottomLeft: const Radius.circular(40.0),
                          bottomRight: const Radius.circular(40.0)),
                    ),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Image.asset(
                          'images/a.png',
                          width: 100,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        //Image.asset('assets/a.png'),
                        new Text("Con tim đau lòng, thương lắm, em ơiiiiiiiiiiii",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ],
                    )),
              )
            ])),
      ],
    );
  }
}
