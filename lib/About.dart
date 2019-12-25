import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_app_flutter/Utilities/Constants.dart';
import 'Services/Authentication.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'Model/User.dart';
import 'EditProfile.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AboutPage extends StatefulWidget {

  AboutPage({this.auth,this.logoutCallback,this.userID});
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userID;
  @override
  _AboutPageState createState() => _AboutPageState(auth: auth,logoutCallback: logoutCallback,userID: userID);


}

class _AboutPageState extends State<AboutPage> {

  _AboutPageState({this.auth,this.logoutCallback,this.userID});
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userID;
  User user;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: FutureBuilder(
        future: usersRef.document(userID).get(),
        builder: (BuildContext context, AsyncSnapshot snapShot) {
          if(!snapShot.hasData){
            return Center(
              child:CircularProgressIndicator(),
            );
          }
          user=User.fromDoc(snapShot.data);

          //User user = User.fromDoc(snapShot.data);
          return Stack(
          children: <Widget>[
          showProfile(),
          ]
          ,
        );
          },
    )
    );
  }
  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.add_circle_outline),
                    title: new Text('Thêm tài khoản'),
                    onTap: () => {}
                ),
                new ListTile(
                  leading: new Icon(Icons.remove_circle_outline),
                  title: new Text('Đăng xuất'),
                  onTap: () => {signOutProcess()},
                ),
              ],
            ),
          );
        }
    );
  }
  _displayProfileImage() {
    // No new profile image

      // No existing profile image
      if (user.avatarUrl.isEmpty) {
        // Display placeholder
        return AssetImage('assets/user_placeholder.jpg');
      } else {
        // User profile image exists
        return CachedNetworkImageProvider(user.avatarUrl);
      }
  }
  Widget showProfile()
  {
    return new ListView(
        children:<Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child:Row(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      _settingModalBottomSheet(context);

                    },
                    child:CircleAvatar(
                      radius: 45.0,
                      backgroundImage: _displayProfileImage(),
                    )
                ),
                Expanded(
                  child:Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text('12',style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              )
                              ),
                              Text('Bài đăng',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  )
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('12',style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              )
                              ),
                              Text('Người theo dõi',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  )
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('12',style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              )
                              ),
                              Text('Đang theo dõi',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  )
                              )
                            ],
                          ),
                        ],
                      ),
                      Container(
                          width: 250.0,
                          child:FlatButton(
                            child: Text('Chỉnh sửa thông tin',
                              style: TextStyle(fontSize: 18.0,color: Colors.white),

                            ),
                            color: Colors.blue,
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>EditProfileScreen(user: user,)));
                            },
                          )
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(user.name,style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,)
                ),
                SizedBox(height: 5.0),
                Container(
                    child: Text(user.bio.replaceAll(RegExp(r'\\n'), '\n'),
                        style: TextStyle(
                          fontSize: 15.0,
                        )
                    )
                ),
                Divider(),
              ],
            ),
          )
        ]
    );
  }


  void signOutProcess() async {
    try {
      await auth.signOut();
      logoutCallback();
    } catch (e) {
      print(e);
    }
  }
}