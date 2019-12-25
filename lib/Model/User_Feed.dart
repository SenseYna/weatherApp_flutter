import 'package:cloud_firestore/cloud_firestore.dart';
class User_Feed
{
  final String id;
  final String caption;
  final String imageUrl;
  final String authorId;
  final String markerId;
  final dynamic likes;
  final Timestamp postdate;

  User_Feed({this.id, this.caption,this.imageUrl,this.authorId,this.markerId,this.likes,this.postdate});

  factory User_Feed.fromDoc(DocumentSnapshot doc)
  {
    return User_Feed(
      id:doc.documentID,
      caption: doc['caption'],
      imageUrl: doc['imageUrl'],
      authorId: doc['authorId'],
      markerId: doc['markerId'],
      likes: doc['likes'],
      postdate: doc['postdate'],
    );
  }

}