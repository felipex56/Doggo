import 'package:doggo/telas/adicionar.dart';
import 'package:doggo/telas/widgetBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


int ab = 10 ;
int c = 12 ;
int cont = 10;


void main() => runApp(new LoginPage());

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key : key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://doggo-7621c.appspot.com/');

  StorageUploadTask _uploadTask;


  Future _startUpload(){
    var imagename = DateTime.now();
    String filePath = 'images/${imagename.toString()}.png';
    var urlImage;

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
    _uploadTask.events.listen((value) {
      if(value.toString() == "success"){
        _storage.ref().child(filePath).getDownloadURL().then((value){
          if(value != null)urlImage = value;
        });
      }
    });
    return urlImage;

  }


  @override
  Widget build(BuildContext context) {
    if(_uploadTask != null){
      return StreamBuilder<StorageTaskEvent>(
          stream : _uploadTask.events,
          builder: (context, snapshot){
            if(snapshot.data != null){
              return Column(
                children: [
                  if(_uploadTask.isComplete)
                    Text('Upload feito com sucesso :) '),

                  if (_uploadTask.isPaused)
                    FlatButton(
                      child: Icon(Icons.play_arrow),
                      onPressed: _uploadTask.resume,
                    ),
                  if (_uploadTask.isInProgress)
                    FlatButton(
                      child: Icon(Icons.pause),
                      onPressed: _uploadTask.pause,
                    ),

                  if(( snapshot.data.snapshot.bytesTransferred /snapshot.data.snapshot.totalByteCount * 100).toInt() != 100)
                    Padding(
                        padding: EdgeInsets.only(left:20, right:20),
                        child:  CircularProgressIndicator()
                    ),
                  Text(
                      '${( snapshot.data.snapshot.bytesTransferred /snapshot.data.snapshot.totalByteCount * 100).toStringAsFixed(2)}% '
                  ),
                ],
              );
            } else{
              return CircularProgressIndicator();
            }
          });
      //https://github.com/felipex56/Doggoo.git
    }else{
      return FlatButton.icon(
        label: Text('Upload para o Firebase'),
        icon: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );
    }

  }

}


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginApp(),
    );
  }
}

class LoginApp extends StatefulWidget {
  @override
  _LoginAppState createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  int _selectedIndex = 0;
  File img;
  List _recognitions;
  static const TextStyle optionStyle = TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Perfil',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    setState(() {
      img = image;
      ab = 12;
    });
    predictImage(image);
  }

  Future predictImage(File image) async {
    if (image == null) return;
    await recognizeImage(image);
    // await recognizeImageBinary(image);
  }

  Future recognizeImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
    });
  }


  Widget _decideImagem() {
    if (ab == 10) {
      return Text("Nenhuma Imagem Selecionada");
    }
    if (ab == 12) {
      return Image.file(img, width: 400, height: 400,);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(child: _decideImagem()),
                Uploader(file: img)
              ],
            )
        ),
         // => _pickImage(ImageSource.gallery)
      ),
      bottomNavigationBar: WidgetBBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddPet()
            ),
          );
        },

        child: Icon(Icons.add_location),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }
}


    /*Container(
        decoration: BoxDecoration(color: const Color(0xFFeeeeee)),
        child: Center(child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),*/
