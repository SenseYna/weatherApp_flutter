import 'package:flutter/material.dart';
import 'package:weather_app_flutter/Login.dart';
import 'Services/Authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weather_app_flutter/Model/User_Info.dart';
import 'package:provider/provider.dart';
import 'HomePage.dart';

bool _isDelayForLoading=false;

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  Future sleep1() {
  return new Future.delayed(const Duration(seconds: 3), () => "1");
}

  delayLoading() async {
      await sleep1();
      _isDelayForLoading = true;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    delayLoading();
    
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isDelayForLoading == true){
      switch (authStatus) {
        case AuthStatus.NOT_DETERMINED:
          return buildWaitingScreen();
          break;
        case AuthStatus.NOT_LOGGED_IN:
          return new LoginPage(
            auth: widget.auth,
            loginCallback: loginCallback,
          );
          break;
        case AuthStatus.LOGGED_IN:
          if (_userId.length > 0 && _userId != null) {
            return new MyApp1(
              userId:_userId,
              auth: widget.auth,
              logoutCallback: logoutCallback,
            );
          } else
            return buildWaitingScreen();
          break;
        default:
          return buildWaitingScreen();
      }
    }
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                height: 590.0,
                width: 600.0,
                decoration: BoxDecoration(

                  // image: DecorationImage(image: NetworkImage(image))),
                    image: DecorationImage(
                        image: AssetImage('assets/images/cloud1.jpg'),
                        fit: BoxFit.fitHeight)),
                child: Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  height: 700.0,
                  width: 600.0,
                  decoration: BoxDecoration(

                    // image: DecorationImage(image: NetworkImage(image))),
                      image: DecorationImage(
                          image: AssetImage('assets/images/logo-eureka.png'))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}