import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:weather_app_flutter/Model/Marker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weather_app_flutter/Utilities/Constants.dart';
import 'infoweather.dart';
import 'package:geolocator/geolocator.dart';

class PinInformation {
  String pinPath;
  String avatarPath;
  LatLng location;
  String locationName;
  Color labelColor;
  PinInformation({
    this.pinPath,
    this.avatarPath,
    this.location,
    this.locationName,
    this.labelColor});
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers={
  };
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  PinInformation sourcePinInfo;
  double pinPillPosition = -800;
  double pinPillPositionBottom=-800;
  double closeButtonPosition=-800;
  //Weather _weather;
  static String infoWeatherMarker;
  bool isDone=false;
  LatLng _center = new LatLng(double.parse(locationInstance.latitude),
        double.parse(locationInstance.longitude));


  getMarker() async {
    QuerySnapshot querySnapshot = await markerRef.getDocuments();
    var list = querySnapshot.documents;
    for(var i = 0; i < list.length; i++){
      MarkerPoint marker = MarkerPoint.fromDoc(list[i]);
      setMapPin(marker);
    }
    isDone=true;

  }

  getDistrict() async
  {
    List<Placemark> placeMark = await Geolocator().placemarkFromCoordinates(10.8705295,106.8031215);
    List<Placemark> districtMark = await Geolocator().placemarkFromCoordinates(10.8494,106.7537);

    print(districtMark[0].subAdministrativeArea==placeMark[0].subAdministrativeArea);
  }

  // LatLng _lastMapPosition;

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }



  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void init() {
    _center = new LatLng(double.parse(locationInstance.latitude),
        double.parse(locationInstance.longitude));
  }

  @override
   void initState() {
    super.initState();


  
  }

  void setMapPin(MarkerPoint markerPoint)
  {
    _markers.add( Marker(
          markerId: MarkerId(markerPoint.id),
          position: new LatLng(markerPoint.markerPoint.latitude,
              markerPoint.markerPoint.longitude),
          icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
              closeButtonPosition=0;
            });
          }
      ),
    );

    sourcePinInfo = PinInformation(
        locationName: 'Start Location',
        location: _center,
        pinPath: "assets/avatar.jpg",
        avatarPath: "assets/picture.jpg",
        labelColor: Colors.blueAccent
    );
  }


  void _hidePinPos()
  {
    setState(() {
      pinPillPosition = -800;
      closeButtonPosition=-800;
    });

  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: FutureBuilder(
      future: getMarker(),
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if(_markers.length<=0){
          return Center(
            child:CircularProgressIndicator(),
          );
        }
        return Stack(
          children: <Widget>[
            _showMap(),
            mapPin(),
            closeButton(),
          ]
          ,
        );
      },
    )
    );
    /*return new Scaffold(
      body: FutureBuilder(
          future: usersRef.document(userID).get(),
          builder: (BuildContext context, AsyncSnapshot snapShot) {}
          body: Stack(
        children: <Widget>[
          _showMap(),
          mapPin(),
          closeButton(),
        ],
      ),
            ));*/
  }

  Widget closeButton()
  {
    return AnimatedPositioned(
      top:closeButtonPosition,
      right: pinPillPosition,
      left: 0,
      duration:Duration(milliseconds: 200) ,
      child: RawMaterialButton(
        onPressed: () {
          _hidePinPos();
        },
        child: new Icon(
          Icons.close,
          color: Colors.white,
          size: 20.0,
        ),
        shape: new CircleBorder(),
        elevation: 2.0,
        fillColor: Colors.blue,
      ),
    );
  }



  Widget mapPin()
  {

    return AnimatedPositioned(
      bottom: pinPillPosition,
      right: 0,
      left: 0,
      duration: Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          //margin: EdgeInsets.all(20),
          height: 650,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(blurRadius: 20, offset: Offset.zero, color: Colors.grey.withOpacity(0.5))
              ]
          ),
          child:  ListView.builder(
              addAutomaticKeepAlives: true,
              itemCount: 100,
              itemBuilder: (context,i)
              {
                if (i.isOdd) {
                  return Divider(
                    color: Colors.blue,
                    thickness: 1.0,
                  );
                }
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
                              child:  Image.asset(currentlySelectedPin.pinPath ),
                            )
                        ),
                        Text(
                          'HoTranThienDat',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,0,0),
                        child: Container(
                          child: Image.network("https://ejoy-english.com/blog/wp-content/uploads/2018/10/Screen-Shot-2017-05-06-at-13.24.02-400x225.png"),
                        )
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.favorite_border,
                          color: Colors.pink,
                          size: 24.0,
                          semanticLabel: 'Text to announce in accessibility modes',
                        ),
                      ],
                    ),
                    Text(
                      'the weather is gorgeous',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                  ],

                );
              }
          ),
            /*(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: () {
                        _hidePinPos();
                      },
                      child: new Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.blue,
                    ),
                  ],

                ),
              ),*/



          ),
        ),
    );

  }

  Widget _showMap() {
    CameraPosition initialLocation = CameraPosition(
      target: _center,
      zoom: 11.0,
    );

    getDistrict();
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              compassEnabled: true,
              markers: _markers,
              mapType: _currentMapType,
              initialCameraPosition: initialLocation,
              onMapCreated: _onMapCreated,
              // handle the tapping on the map
              // to dismiss the info pill by
              // resetting its position
              onTap: (LatLng location) {
              },
              //  onCameraMove: _onCameraMove,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: _onMapTypeButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.blue.withOpacity(0.7),
                      child: const Icon(Icons.map, size: 36.0),
                    ),
                    SizedBox(height: 16.0),
                    // FloatingActionButton(
                    //   onPressed: _onAddMarkerButtonPressed,
                    //   materialTapTargetSize: MaterialTapTargetSize.padded,
                    //   backgroundColor: Colors.green,
                    //   child: const Icon(Icons.add_location, size: 36.0),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}
