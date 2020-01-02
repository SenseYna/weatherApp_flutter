import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:weather_app_flutter/Model/Marker_Feed.dart';
import 'package:weather_app_flutter/Model/User_Feed.dart';
import 'package:weather_app_flutter/Model/User.dart';
import 'package:weather_app_flutter/Services/Database.dart';
import 'package:weather_app_flutter/Model/Marker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weather_app_flutter/Utilities/Constants.dart';
import 'infoweather.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'About.dart';


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
  String currentMarker;
  //Weather _weather;
  static String infoWeatherMarker;
  bool isDone=false;
  bool isHavePost=false;
  bool isLoadFeedDone=false;
  MarkerPoint currentMarkerInfo;
  List<User_Feed> _Post=[];
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


  displayFeed(String markerId) async{

    List<User_Feed>_post = await DatabaseService.getMarkerFeed(markerId);
    MarkerPoint marker = await DatabaseService.getMarkerInfo(markerId);
    setState(() {
      _Post=_post;
      currentMarkerInfo = marker;
      if(_Post.length>0)
        {
          isHavePost=true;

        }
      else
        isHavePost=false;
      isLoadFeedDone=true;
    });




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
              currentMarker=markerPoint.id;
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
      _Post.clear();
      currentMarker=null;
      isLoadFeedDone=false;
      isHavePost=true;
      currentMarkerInfo= null;
    });

  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(


        body: FutureBuilder(
      future: getMarker(),
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if( !isDone){
          return Center(
            child:CircularProgressIndicator(),
          );
        }
        return Stack(
          children: <Widget>[
            _showMap(),
            mapPin(),
          ]
          ,
        );
      },
    )
    );

  }




  Widget mapPin()
  {
    return AnimatedPositioned(
      top:pinPillPosition,
      right: 0,
      left: 0,
      duration: Duration(milliseconds: 200),
      child:  Wrap(
        direction: Axis.horizontal,
        children: <Widget>[

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              //margin: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height-130,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(blurRadius: 20, offset: Offset.zero, color: Colors.grey.withOpacity(0.5))
                ],
              ),
              child: RefreshIndicator(
                onRefresh:()=> _refreshFeed() ,
                child:_setUpFeed(),

              ),
            ),
          ),
        ],

    )

    );
  }

  _refreshFeed()  async
  {
    setState(() {
      _Post.clear();
      isLoadFeedDone=false;
      isHavePost=true;
      currentMarkerInfo= new MarkerPoint();
    });
    await displayFeed(currentMarker);
  }

  Widget _setUpFeed()
  {
    if(currentMarker==null)
      {
        isLoadFeedDone=false;
        return new Scaffold();
      }

    return new Scaffold(
      body:FutureBuilder(
        future: displayFeed(currentMarker),
        builder: (BuildContext context, AsyncSnapshot snapShot) {

          if(!isLoadFeedDone){
            return Center(
              child:CircularProgressIndicator(),
            );
          }

          return CustomScrollView(
            cacheExtent: 1000,
              slivers: <Widget>[
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              centerTitle:true,
              title: Text(currentMarkerInfo.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  )),
                  background: Row(
                  children: <Widget>[
                       Spacer(),
                      CircleAvatar(
                        radius: 54.0,
                        backgroundImage: AdvancedNetworkImage(
                        currentMarkerInfo.markerPicture,
                        useDiskCache: true,
                        cacheRule: CacheRule(maxAge: const Duration(days: 7)),
          ),
                    ),
                    Spacer(),
                    ],
          )
          ),
            expandedHeight: 200,
            floating: false,
            pinned: true,
            snap: false,
            backgroundColor: Colors.black12,
            actions: <Widget>[
              FloatingActionButton(
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.clear,
                ),
                elevation: 0,
                onPressed: () => {
                  _hidePinPos()
                },
              ),
            ],
          ),
            SliverList(
            delegate: SliverChildBuilderDelegate(
              (context,index)=>  FutureBuilder(
              future: DatabaseService.getUserInfo(_Post[index].authorId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      )
                  );
                }
                User author = snapshot.data;
                return _buildPost(_Post[index], author);
              }
          ),
            childCount: _Post.length ,
          )
          )],
          );
        },
      ),
    );
  }
  Widget _buildPost(User_Feed post, User author){

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
                          userID: author.id ))),
                        child:CircleAvatar(
                          radius: 45.0,
                          backgroundImage:  AdvancedNetworkImage(
                            author.avatarUrl,
                            useDiskCache: true,
                            cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                          ),
                        )
                    ),
                  )
              ),
              Text(
                author.name,
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
                    post.imageUrl,
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
                      author.name,
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
                  calculateDate(post.postdate),
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
  Widget _showMap() {
    CameraPosition initialLocation = CameraPosition(
      target: _center,
      zoom: 11.0,
    );

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
                      heroTag: "btn1",
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
