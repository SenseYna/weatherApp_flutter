import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weather_app_flutter/Model/Marker.dart';
import 'package:weather_app_flutter/Model/User_Feed.dart';
import 'package:weather_app_flutter/Utilities/Constants.dart';
import 'package:weather_app_flutter/Model/User.dart';


class DatabaseService {
  static void updateUser(User user) {
    usersRef.document(user.id).updateData({
      'name': user.name,
      'avatarUrl': user.avatarUrl,
      'bio': user.bio,
    });
  }

  static Future<QuerySnapshot> searchUsers(String name) {
    Future<QuerySnapshot> users =
    usersRef.where('name', isGreaterThanOrEqualTo: name).getDocuments();
    return users;
  }
  static Future<List<User_Feed>> getMarkerFeed(String markerId) async{
   QuerySnapshot feedSnapshot= await markerRef
       .document(markerId)
       .collection('feedPosts')
       .orderBy('postdate',descending: true)
       .getDocuments();
   List<User_Feed> feeds=feedSnapshot.documents.map((doc)=>User_Feed.fromDoc(doc)).toList();
   return feeds;
  }
  static Future<List<User_Feed>> getUserPost(String userId) async{
    QuerySnapshot feedSnapshot= await postsRef
        .document(userId)
        .collection('usersPosts')
        .orderBy('postdate',descending: true)
        .getDocuments();
    List<User_Feed> feeds=feedSnapshot.documents.map((doc)=>User_Feed.fromDoc(doc)).toList();
    return feeds;
  }
  static void  createPost(User_Feed post)
  {
    postsRef.document(post.authorId).collection('usersPosts').add({
      'imageUrl': post.imageUrl,
      'caption':post.caption,
      'likes':post.likes,
      'markerId':post.markerId,
      'authorId':post.authorId,
      'postdate':post.postdate,
    });
    markerRef.document(post.markerId).collection('feedPosts').add({
      'imageUrl': post.imageUrl,
      'caption':post.caption,
      'likes':post.likes,
      'authorId':post.authorId,
      'postdate':post.postdate,
    });
  }
  static Future<User>  getUserInfo(String userId) async
  {
    DocumentSnapshot user = await usersRef.document(userId).get();
    if(user.exists){
      return User.fromDoc(user);
    }
    else
      return User();

  }
  static Future<MarkerPoint> getMarkerInfo(String markerId) async
  {
    DocumentSnapshot markerPoint = await markerRef.document(markerId).get();
    if(markerPoint.exists){
      return MarkerPoint.fromDoc(markerPoint);
    }
    else
      return MarkerPoint();
  }
}