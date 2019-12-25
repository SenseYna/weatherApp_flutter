import 'package:cloud_firestore/cloud_firestore.dart';
class User
{
  final String id;
  final String name;
  final String bio;
  final int postCount;
  final String avatarUrl;
  final String email;

  User({this.id, this.name,this.bio,this.postCount,this.avatarUrl,this.email});

  factory User.fromDoc(DocumentSnapshot doc)
  {
    return User(
      id:doc.documentID,
      name: doc['name'],
      bio: doc['bio'] ?? '',
      postCount: doc['postCount'],
      avatarUrl: doc['avatarUrl'],
      email: doc['email'],
    );
  }

}