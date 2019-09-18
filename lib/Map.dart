import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'infolocation.dart';
import 'infoweather.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  //Weather _weather;
  static String infoWeatherMarker;
  static LatLng _center = new LatLng(double.parse(locationInstance.latitude),
        double.parse(locationInstance.longitude));

  // _generateData() async {
  //   if (!weatherInstance.isEmpty()) {
  //     _weather = weatherInstance;
  //   } else {
  //     MyLocation _myLocation = new MyLocation();
  //     await _myLocation.getPos();
  //     await _weather.fetchData(_myLocation.latitude, _myLocation.longitude);
  //     _center = new LatLng(_myLocation.latitude, _myLocation.longitude);
  //   }
  //   weatherInstance = _weather;

  //   // infoWeatherMarker =

  //   //     _weather.displayName.toString();
  //   // +
  //   //  "Nhiệt độ: " +
  //   // _weather.curently.temperature.toStringAsFixed(2) +
  //   // "°C" +
  //   // "\n" +
  //   // "Chỉ số tia cực tím: " +
  //   // _weather.curently.uvIndex.toString() +
  //   // "\n";
  // }

  Completer<GoogleMapController> _controller = Completer();

  // LatLng _lastMapPosition;

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  // void _onAddMarkerButtonPressed() {
  //   setState(() {
  //     _markers.add(Marker(
  //       // This marker id can be anything that uniquely identifies each marker.
  //       markerId: MarkerId(_lastMapPosition.toString()),
  //       position: _lastMapPosition,
  //       infoWindow: InfoWindow(
  //         title: 'Thông tin thời tiết',
  //         snippet: infoWeatherMarker
  //       ),
  //       icon: BitmapDescriptor.defaultMarker,
  //     ));
  //   });
  // }

  // void _onCameraMove(CameraPosition position) {
  //   _lastMapPosition = position.target;
  // }

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

  final Set<Marker> _markers = {
    Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(_center.toString()),
      position: _center,
      infoWindow: InfoWindow(
        title: 'Vị trí hiện tại của bạn!!',
        //  snippet: infoWeatherMarker,
      ),
      icon: BitmapDescriptor.defaultMarker,
    
    ),
  };

  Widget build(BuildContext context) {
    //   print(_center.latitude.toString()+'aaaaaaaaaaaaaaaaaaa');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
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
