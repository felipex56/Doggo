import 'dart:io';

import 'package:doggo/autentication/autenteicacao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:doggo/home/camera_helper.dart';
import 'package:doggo/home/tflite_helper.dart';
import 'package:doggo/models/tflite_result.dart';
import 'package:doggo/telas/widgetBar.dart';
import 'package:google_maps_webservice/geolocation.dart';
import 'package:geolocator/geolocator.dart';

import 'adicionar2.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
final AuthService _auth = AuthService();



class _HomePageState extends State<HomePage> {
  File _image;
  List<TFLiteResult> _outputs = [];

  GoogleMapController mapController;

  final LatLng _center = const LatLng(-19.8157, -43.9542);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getPosition();
  }

  _getPosition() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 15.0,tilt: 20)));
    print("****************");
    print(position);
  }


  @override
  void initState() {
    super.initState();
    TFLiteHelper.loadModel();
  }

  @override
  void dispose() {
    TFLiteHelper.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: AppBar(
          backgroundColor: Colors.orange[600],
          elevation:0.0,
          title: Text('Doggo'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPetPage()),
          );
        },
        backgroundColor: Color(0xffeb6e57),
        child: Icon(Icons.add_location),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 10.0,
        ),
        mapType: MapType.hybrid,

      ),
      bottomNavigationBar: WidgetBBar(),
    );
  }

}
