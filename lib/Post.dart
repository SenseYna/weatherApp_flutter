import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app_flutter/Services/Storage.dart';
import 'package:weather_app_flutter/Services/Database.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_flutter/Model/User_Feed.dart';
import 'package:weather_app_flutter/Model/User_Info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'infoweather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_flutter/Model/Marker.dart';
import 'package:weather_app_flutter/Utilities/Constants.dart';

class PostPage extends StatefulWidget {

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  File _image;
  TextEditingController _captionController = TextEditingController();
  String _caption = '';
  bool _isLoading = false;
  String _markerId='';
  LatLng _center = new LatLng(double.parse(locationInstance.latitude),
      double.parse(locationInstance.longitude));
  _showPickImage()
  {
    return Platform.isAndroid ? _androidDialog() : _iosSheet();
  }

  getDistrict() async
  {
    List<Placemark> placeMark = await Geolocator().placemarkFromCoordinates(_center.latitude,_center.longitude);
    QuerySnapshot querySnapshot = await markerRef.getDocuments();
    var list = querySnapshot.documents;
    for(var i = 0; i < list.length; i++) {
      MarkerPoint marker = MarkerPoint.fromDoc(list[i]);
      if(marker.name==placeMark[0].subAdministrativeArea)
        {
          _markerId= MarkerPoint.fromDoc(list[i]).id;
        }

      print(_markerId);
    }

  }

  _androidDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return SimpleDialog(
            title: Text('Thêm ảnh'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Chụp Ảnh'),
                onPressed: ()=>_handleImage(ImageSource.camera ),
              ),
              SimpleDialogOption(
                child: Text('Chọn từ thư viện ảnh'),
                onPressed: ()=>_handleImage(ImageSource.gallery),
              ),
              SimpleDialogOption(
                child: Text('Hủy',
                style: TextStyle(
                  color:Colors.redAccent,
                ),
                ),
                onPressed: ()=>Navigator.pop(context),
              )
            ],
          );

          },
    );
  }


   _handleImage(ImageSource source) async{
    Navigator.of(context, rootNavigator: true).pop();
    File imageFile = await ImagePicker.pickImage(source: source);
    if(imageFile!=null) {
      setState(() {
        _image = imageFile;
      });
    }

  }

  _iosSheet(){
    print('ios');
  }

  _post() async{
    if(!_isLoading && _image!=null && _caption.isNotEmpty){
      setState(() {
        _isLoading=true;

      });
      getDistrict();
      //Tao bai dang
      String imageUrl = await StorageService.uploadPost(_image);
      User_Feed post= User_Feed(
        imageUrl: imageUrl,
        caption: _caption,
        likes: {},
        markerId: _markerId,
        authorId: Provider.of<UserData>(context).currentUserId,
        postdate: Timestamp.fromDate(DateTime.now()),
      );


      DatabaseService.createPost(post);

      _captionController.clear();
      setState(() {
        _caption='';
        _image=null;
        _isLoading=false;

      });
    }
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('Chia sẻ',
                style: new TextStyle(color: Colors.white)),
            onPressed: _post,
          ),
        ));
  }
  Widget showCaptionInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: new TextField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
       controller: _captionController,
        autofocus: false,
        decoration: InputDecoration(
            labelText: 'Caption',
            ),
        onChanged: (input)=>_caption=input,
      ),
    );
  }
  Widget build(BuildContext context) {

    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    return new Scaffold(
      body: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
      child:ConstrainedBox(
        constraints:
        BoxConstraints(minHeight:height),
       child: Column(
        children: <Widget>[
          _isLoading ?
              Padding(
                padding: EdgeInsets.only(bottom: 0.0),
                child: LinearProgressIndicator(backgroundColor: Colors.blue[200],
                valueColor: AlwaysStoppedAnimation(Colors.blue),),
              )
          : SizedBox.shrink(),
          GestureDetector(
            onTap: _showPickImage,
            child: Container(
            height: width,
            width: width,
            color: Colors.grey[300],
            child: _image ==null ? Icon(
                Icons.add_a_photo,
              color: Colors.white70,
              size: 150.0,
            ): Image(
              image: FileImage(_image),
              fit:BoxFit.cover,
            ),
          )
          ),
          SizedBox(height: 20.0),
          showCaptionInput(),
          showPrimaryButton(),
          SizedBox(height: 20.0),

        ],
      ),
    ),
    ),
      ),
    );
  }
}
