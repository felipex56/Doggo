import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:doggo/autentication/autenteicacao.dart';
import 'package:doggo/models/pin_data.dart';
import 'package:doggo/models/pin_data.dart';
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
import 'detailPet.dart';

class PinData {
  String avatarPath;
  String locationName;
  Color labelColor;

  PinData({String avatarPath, String locationName, MaterialColor labelColor});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final AuthService _auth = AuthService();

class _HomePageState extends State<HomePage> {
  File _image;
  List<TFLiteResult> _outputs = [];

  GoogleMapController mapController;
  Iterable markers = [];

  QuerySnapshot q;

  final LatLng _center = const LatLng(-19.8157, -43.9542);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    /* _getPosition(); */
  }

/*   _getPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 10.0,
        tilt: 20)));
    print(position);
  } */

  double _pinPillPosition = -100;
  PinData _currentPinData = PinData(
      avatarPath: 'aa', locationName: 'testeteste', labelColor: Colors.grey);

  PinData _sourcePinInfo;

  @override
  void dispose() {
    TFLiteHelper.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    TFLiteHelper.loadModel();
    getData();
  }

  getPet() async {
    final db = Firestore.instance;

    QuerySnapshot qn = await db.collection("Pet").getDocuments();
    return qn.documents;
  }

  getData() async {
    List<DocumentSnapshot> snp = await getPet();
    print("**************");
    print(snp.sublist(0));
    print(snp.sublist(0)[0]);
    print(snp.sublist(0)[0]["raca"]);
    print(snp.length);
    print(snp.sublist(0).length);
    final int tamanho = snp.length;
    try {
      Iterable _markers = Iterable.generate(tamanho, (index) {
        double latt = double.tryParse(snp[index].data['latitude']);
        double longg = double.tryParse(snp[index].data['longitude']);
        LatLng latLngMarker = LatLng(latt, longg);
        print("3************************$index");
        print(double.tryParse(snp[index].data['latitude']));
        print(double.tryParse(snp[index].data['longitude']));
        return Marker(
            markerId: MarkerId("marker$index"),
            position: latLngMarker,
            onTap: () {
              petModal(snp[index].data['raca'], snp[index].data['description'],
                  snp[index].data['image'], snp[index].data['local'], index);
//              setState(() {
//                _setMapPins(snp[index].data['image'],snp[index].data['local'],index);
//                _currentPinData = _sourcePinInfo;
//                _pinPillPosition = 0;
//              });
            }
//            onTap: (){
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => DetailPet(index)));
//            }

            );
      });

      setState(() {
        markers = _markers;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _setMapPins(avatar, location, id) {
    setState(() {
      _sourcePinInfo = PinData(
          avatarPath: avatar, locationName: location, labelColor: Colors.blue);
    });
    print('prest');
    print(_currentPinData.locationName);
    print(_currentPinData.avatarPath);
    print(_sourcePinInfo.locationName);
    print(_sourcePinInfo.avatarPath);
    ;
  }

  void petModal(name, descr, avatar, location, id) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Color(0xffebbd57),
          child: SingleChildScrollView(
            child: Stack(children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: 70,
                        height: 70,
                        child: ClipOval(
                          child: FutureBuilder(
                            future: _buildImage(avatar),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> image) {
                              if (image.hasData) {
                                return image.data; // image is ready
                              } else {
                                return Image.network(
                                  "https://imamt.org.br/wp-content/themes/imamt/images/notfound.png",
                                  fit: BoxFit.cover,
                                ); // placeholder
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(name),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(location),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(descr),
                  ),
                  RaisedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailPet(id))
                    ),
                    child: Text('Ver mais informações'),
                  )
                ],
              ),
              Positioned(
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ),
              )
            ]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPinData.locationName == null) {
      setState(() {
        _currentPinData.locationName = 'Erro ao obter o local';
      });
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: AppBar(
          backgroundColor: Colors.orange[600],
          elevation: 0.0,
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
      body: Stack(children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          markers: Set.from(markers),
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 10.0,
          ),
          mapType: MapType.hybrid,
        ),
        AnimatedPositioned(
          bottom: _pinPillPosition,
          right: 0,
          left: 0,
          duration: Duration(milliseconds: 200),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.all(20),
              height: 70,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      blurRadius: 20,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5),
                    )
                  ]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width: 50,
                    height: 50,
                    child: ClipOval(
                      child: FutureBuilder(
                        future: _buildImage(_currentPinData.avatarPath),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> image) {
                          if (image.hasData) {
                            return image.data; // image is ready
                          } else {
                            return Image.network(
                              "https://imamt.org.br/wp-content/themes/imamt/images/notfound.png",
                              fit: BoxFit.cover,
                            ); // placeholder
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _currentPinData.locationName,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
      bottomNavigationBar: WidgetBBar(),
    );
  }

  _buildImage(name) async {
    final ref = FirebaseStorage.instance.ref().child('pets/$name.jpg');
// no need of the file extension, the name will do fine.
    var url = await ref.getDownloadURL();
    return Image.network(
      url,
      fit: BoxFit.cover,
    );
  }
}
