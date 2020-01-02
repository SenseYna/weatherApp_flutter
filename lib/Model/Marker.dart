import 'package:cloud_firestore/cloud_firestore.dart';
class MarkerPoint
{
  final String id;
  final GeoPoint markerPoint;
  final String name;
  final String markerPicture;

  MarkerPoint({this.id,this.markerPoint,this.name,this.markerPicture });

  factory MarkerPoint.fromDoc(DocumentSnapshot doc)
  {
    return MarkerPoint(
      id:doc.documentID,
      markerPoint: doc['markerpoint'],
      name: doc['name'],
      markerPicture: doc['markerPicture'],
    );
  }

}