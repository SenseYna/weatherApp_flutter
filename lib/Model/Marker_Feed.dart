import 'package:cloud_firestore/cloud_firestore.dart';
class MarkerFeed
{
  final String authorId;
  final String caption;
  final String imageUrl;
  final int likes;
  final Timestamp postdate;


  MarkerFeed({this.authorId, this.caption,this.imageUrl,this.likes,this.postdate});

  factory MarkerFeed.fromDoc(DocumentSnapshot doc)
  {
    return MarkerFeed(
      authorId: doc['authorId'],
      caption: doc['caption'],
      imageUrl: doc['imageUrl'],
      likes: doc['likes'],

    );
  }

}