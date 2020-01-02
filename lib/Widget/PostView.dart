import 'dart:async';
import 'package:animator/animator.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter/material.dart';
import 'package:weather_app_flutter/Model/User_Feed.dart';
import 'package:weather_app_flutter/Model/User.dart';
import 'package:weather_app_flutter/Services/Database.dart';
import 'package:weather_app_flutter/About.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class PostView extends StatefulWidget {
  final String currentUserId;
  final User_Feed post;
  final User author;

  PostView({this.currentUserId, this.post, this.author});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {




  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(10,10,10,10),
                child: Container(
                  height:50.0,
                  width:50.0,
                  child:  GestureDetector(
                      onTap: () =>Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_)=>AboutPage(
                                  userID: widget.author.id ))),
                      child:CircleAvatar(
                        radius: 45.0,
                        backgroundImage:  AdvancedNetworkImage(
                          widget.author.avatarUrl,
                          useDiskCache: true,
                          cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                        ),
                      )
                  ),
                )
            ),
            Text(
              widget.author.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(0,0,0,0),
            child: Container(
              child: Image(
                image:AdvancedNetworkImage(
                  widget.post.imageUrl,
                  useDiskCache: true,
                  cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                ),
              ),
            )
        ),

        Wrap(
          direction: Axis.horizontal,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(5,10,0,0),
                child: Container(
                  child:   Text(
                    widget.author.name,
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
                    widget.post.caption,
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
                calculateDate( widget.post.postdate),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black.withOpacity(0.4),fontSize: 11),
                textAlign: TextAlign.left,
              ),
            )
        ),
        Divider(),

      ],
    );

  }
}
String calculateDate(Timestamp postDate)
{
  String returnDate="";
  DateTime now = DateTime.now();
  if(now.year==postDate.toDate().year){
    if(now.month==postDate.toDate().month){
      if(now.day==postDate.toDate().day){
        if(now.hour==postDate.toDate().hour){
          returnDate=(now.minute-postDate.toDate().minute).toString() + " phút trước";
        }
        else{
          returnDate=(now.hour-postDate.toDate().hour).toString() + " giờ trước";
        }
      }
      else{
        returnDate=(now.day-postDate.toDate().day).toString() + " ngày trước";
      }
    }
    else{
      returnDate=(now.month-postDate.toDate().month).toString() + " tháng trước";
    }
  }
  else{
    returnDate= "ảnh từ "+postDate.toDate().day.toString() +"/"+ postDate.toDate().month.toString()+"/"+ postDate.toDate().year.toString();
  }
  return returnDate;
}