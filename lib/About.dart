import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_flutter/Model/User_Feed.dart';
import 'package:weather_app_flutter/Services/Database.dart';
import 'package:weather_app_flutter/Utilities/Constants.dart';
import 'Services/Authentication.dart';
import 'Model/User_Info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Model/User.dart';
import 'EditProfile.dart';

import 'package:weather_app_flutter/Widget/PostView.dart';

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
  List<User_Feed> _posts=[];
  int _postView=1;
  Timer _showDialogTimer;
  bool _dialogVisible = false;
  User_Feed currentPost;


  @override
  void initState() {
    super.initState();
    _setupPosts();


  }

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
          final layers = <Widget>[];
          layers.add(showProfile());
          if(_dialogVisible) {
            layers.add(_buildDialog(currentPost));
          }
          //User user = User.fromDoc(snapShot.data);
          return Stack(
            fit: StackFit.expand,
          children: layers,
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

  _setupPosts() async{
    List<User_Feed> posts= await DatabaseService.getUserPost(widget.userID);
    setState(() {
      _posts=posts;
    });
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
                _avatarBuild(user),
                _mainScreenBuild(user),

              ],
            ),
          ),
          _bioBuild(user),
          _toggleButtonBuild(),
          Divider(),
          _buildDisplayPosts(),
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

  _avatarBuild(User user)
  {
    return user.id== Provider.of<UserData>(context).currentUserId ?
    GestureDetector(
        onTap: () {
          _settingModalBottomSheet(context);

        },
        child:CircleAvatar(
          radius: 45.0,
          backgroundImage: _displayProfileImage(),
        )
    ):  Container(
        width: MediaQuery.of(context).size.width-40,
        child:Wrap(
            children: <Widget>[
              Container(
                width: 30,
                child:FloatingActionButton(

                  backgroundColor: Colors.black38,
                  child: Icon(
                    Icons.arrow_back,
                  ),
                  elevation: 0,
                  onPressed: () => {
                  Navigator.pop(context),
                  },
                ),
              ),

              Align(
                alignment: Alignment.center,
                  child:CircleAvatar(
                    radius: 50.0,
                    backgroundImage: _displayProfileImage(),
                    )
              ),

              ],

            ),
        );
  }

  _bioBuild(User user)
  {
    return user.id== Provider.of<UserData>(context).currentUserId ?
    Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
          ],
        )
   : Padding(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
          alignment: Alignment.center,
          child: Text(user.name,style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,)
          )),
             SizedBox(height: 5.0),
            Container(
                child:Align(
                    alignment: Alignment.center,
                    child: Text(user.bio.replaceAll(RegExp(r'\\n'), '\n'),
                        style: TextStyle(
                          fontSize: 15.0,
                        )
                    )
                )
            ),
             Divider(),
        ],
        )
    );


  }
  _editProfileBuild(User user)
  {
    return user.id== Provider.of<UserData>(context).currentUserId ?
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
    ):Container(
        width: 250.0,
    );
  }
  _mainScreenBuild(User user)
  {
    return user.id== Provider.of<UserData>(context).currentUserId ?
    Expanded(
      child:Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              Column(
                children: <Widget>[
                  Text(_posts.length.toString(),style: TextStyle(
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

            ],
          ),
          _editProfileBuild(user),
        ],
      ),
    ):Container(

    );
  }
  _toggleButtonBuild()
  {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on),
          iconSize: 30.0,
          color: _postView == 0
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
          onPressed: () => setState(() {
            _postView = 0;
          }),
        ),
        IconButton(
          icon: Icon(Icons.list),
          iconSize: 30.0,
          color: _postView == 1
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
          onPressed: () => setState(() {
            _postView = 1;
          }),
        ),
      ],
    );
  }

  _buildTilePost(User_Feed post) {
    return GestureDetector(
      onTapDown: (_) => {
      setState(() {
       currentPost=post;

      }
      )},
      onTapUp: (_)=>{
      setState(() {
      currentPost=null;

      }
      )},
      child: Image(
        image: CachedNetworkImageProvider(post.imageUrl),
        fit: BoxFit.cover,
      ),
    );


  }

  void _onPointerDown(PointerDownEvent event) {
    _showDialogTimer = Timer(Duration(milliseconds: 200), _showDialog);
  }

  void _onPointerUp(PointerUpEvent event) {
    _showDialogTimer?.cancel();
    _showDialogTimer = null;
    setState(() {
      _dialogVisible = false;
    });
  }

  void _showDialog() {
    setState(() {
      _dialogVisible = true;
    });
  }

  Widget _buildPage(User_Feed post) {

    return GridTile(
        child:   Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
          child: _buildTilePost(post),
         )
    );
  }

  Widget _buildDialog(User_Feed post) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      padding: EdgeInsets.fromLTRB( 0, 50,0, 250),
      child:  BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 6,
            ),
            child: Container(
                height:MediaQuery.of(context).size.height/2 ,
                decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          blurRadius: 20,
                          offset: Offset.zero,
                          color: Colors.grey.withOpacity(0.5)
                      )]
                ),
                child:  Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10,10,10,10),
                        child: Container(
                          height:50.0,
                          width:50.0,
                          child: CircleAvatar(
                                radius: 45.0,
                                backgroundImage:  AdvancedNetworkImage(
                                  user.avatarUrl,
                                  useDiskCache: true,
                                  cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                                ),
                              )
                        )
                    ),
                    Text(
                      user.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,0),
                     child:Container(
                       height: 270,
                       child: Image(
                         image:CachedNetworkImageProvider(
                           post.imageUrl
                         ),
                         fit: BoxFit.fitWidth,
                       ),
                     ) ,
                ),
                Wrap(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.fromLTRB(5,10,0,0),
                        child: Container(
                          child:   Text(
                            user.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(5,10,0,0),
                        child: Container(
                          child:   Text(
                            post.caption,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.normal),
                            textAlign: TextAlign.left,
                          ),
                        )
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(5,10,0,0),
                    child: Container(
                      child:   Text(
                        calculateDate( post.postdate),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black.withOpacity(0.4),fontSize: 11),
                        textAlign: TextAlign.left,
                      ),
                    )
                ),


              ],
            ),
      )
      )// end of Container

    );
  }

  _buildDisplayPosts() {
    if (_postView == 0) {
     // Grid
      List<GridTile> tiles = [];
      _posts.forEach(
            (post) => tiles.add(_buildPage(post)),
      );
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: tiles,
      );
    } else {
      // Column
      List<PostView> postViews = [];
      _posts.forEach((post) {
        postViews.add(
          PostView(
            currentUserId: widget.userID,
            post: post,
            author: user,
          ),
        );
      });
      return Column(children: postViews);
    }
  }
}