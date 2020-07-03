import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doggo/telas/pets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:doggo/telas/widgetBar.dart';
import 'package:doggo/autentication/autenteicacao.dart';
import 'package:geocoder/geocoder.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:doggo/home/camera_helper.dart';
import 'package:doggo/home/tflite_helper.dart';
import 'package:doggo/models/tflite_result.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

//void main() => runApp(new AddPetPage());

const kGoogleApiKey = "AIzaSyAci-DFKpBOF_eJDfU4AEuZctrB3TQ-Rk8";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class AddPetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddPet(),
    );
  }
}

class AddPet extends StatefulWidget {
  @override
  _AddPetState createState() => _AddPetState();
}

final AuthService _auth = AuthService();

class _AddPetState extends State<AddPet> {
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String local;
  String raca;
  String description;
  String latitude = '';
  String longitude = '';
  File _image;
  String _uploadedFileURL;
  List<TFLiteResult> _outputs = [];
  var txt = TextEditingController();

  final idpet = UniqueKey().toString();

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
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: const Color(0xFFeeeeee)),
        child: Stack(
          children: <Widget>[
            Transform.scale(
              scale: 2.0,
              child: Container(
                width: 746,
                height: 746,
                transform: Matrix4.translationValues(0, -250, 0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.5, 0.21),
                    end: Alignment(0.5, 0.77),
                    colors: [Color(0xffebbd57), Color(0xffeb6e57)],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Center(
              child: Container(
                width: 318,
                height: 480,
                transform: Matrix4.translationValues(0, 40, 0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 3),
                      blurRadius: 6,
                      color: const Color(0xff000000).withOpacity(0.16),
                    )
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _buildImage(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 160,
                                padding: EdgeInsets.fromLTRB(0,0,10,0),
                                child: TextFormField(
                                  onTap: () async {
                                    // show input autocomplete with selected mode
                                    // then get the Prediction selected
                                    Prediction p = await PlacesAutocomplete.show(
                                        context: context, apiKey: kGoogleApiKey);
                                    displayPrediction(p);
                                    txt.text = p.description;
                                  },
                                  controller: txt,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Local",
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Digite o Local.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => local = value,
                                ),
                              ),
                              _image == null ?

                              FlatButton(
                                onPressed: _pickImage,
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.camera_alt),
                                    Text(
                                      "Enviar Imagem",
                                    ),
                                  ],
                                ),
                              )

                                  : Text(''),

                            ],
                          )
                        ],
                      ),
                      /*Container(
                        width: 272,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Raça",
                          ),
                          enabled: false,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Preencha a Raça.';
                            }
                            return null;
                          },
                          onSaved: (value) => raca = value,
                        ),
                      ),*/
                      _buildResult(),
                      Container(
                        width: 272,
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 8,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Descrição",
                          ),
                          onSaved: (value) => description = value,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createData,
        child: Icon(Icons.save),
      ),
    );
  }

  _buildImage() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 92.0),
        child: Container(
          child: Center(
            child: _image == null
                ? Text('Sem imagem')
                : Image.file(
                    _image,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  _pickImage() async {
    final image = await CameraHelper.pickImage();
    if (image == null) {
      return null;
    }

    final outputs = await TFLiteHelper.classifyImage(image);

    setState(() {
      _image = image;
      _outputs = outputs;
    });
  }

  _buildResult() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Container(
        height: 90.0,
        child: _buildResultList(),
      ),
    );
  }

  _buildResultList() {
    if (_outputs.isEmpty) {
      return Center(
        child: Text('Sem resultados'),
      );
    }

    return Center(
      child: ListView.builder(
        itemCount: _outputs.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Text(
                '${_outputs[index].label} ( ${(_outputs[index].confidence * 100.0).toStringAsFixed(2)} % )',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10.0,
              ),
              LinearPercentIndicator(
                lineHeight: 14.0,
                percent: _outputs[index].confidence,
              ),
            ],
          );
        },
      ),
    );

  }

  void createData() async {
    raca = _outputs[0].label;
    try{
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseUser user = await auth.currentUser();
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        DocumentReference ref = await db.collection('Pet').add({
          'user': user.uid,
          'local': '$local',
          'raca': '$raca',
          'description': '$description',
          'perdido': true,
          'data': new DateTime.now(),
          'image':idpet,
          'latitude':'$latitude',
          'longitude':'$longitude',
        });
        setState(() => id = ref.documentID);
        print("****************************");
        print(ref.documentID);
    }
    }
    catch(e){
      print("*********");
      print(e);
    }



    await uploadFile();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyPetPage()),
    );
  }

  Future uploadFile() {

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('pets/${idpet}.jpg');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);

      print(lat);
      print(lng);

      setState(() {
        latitude = lat.toString();
        longitude = lng.toString();
      });
    }
  }

}
