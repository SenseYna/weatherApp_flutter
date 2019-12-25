import 'package:cloud_firestore/cloud_firestore.dart';
class MarkerPoint
{
  final String id;
  final GeoPoint markerPoint;

  MarkerPoint({this.id,this.markerPoint });

  factory MarkerPoint.fromDoc(DocumentSnapshot doc)
  {
    return MarkerPoint(
      id:doc.documentID,
      markerPoint: doc['markerpoint'],
    );
  }

}