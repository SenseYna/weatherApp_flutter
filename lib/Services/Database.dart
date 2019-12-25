import 'package:cloud_firestore/cloud_firestore.dart';
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
  }
}