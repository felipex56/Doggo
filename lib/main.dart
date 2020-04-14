import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

int ab = 10 ;
int c = 12 ;
int cont = 10;


void main() async{
  runApp(Meuapp());
}
class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key : key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://doggo-7621c.appspot.com/');

  StorageUploadTask _uploadTask;

  void _startUpload(){
    String filePath = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }
  @override
  Widget build(BuildContext context) {
    if(_uploadTask != null){
      return StreamBuilder<StorageTaskEvent>(
        stream : _uploadTask.events,
        builder: (context, snapshot){
          var event = snapshot?.data?.snapshot;
          double progressPercent = event != null
          ? event.bytesTransferred / event.totalByteCount
              : 0;
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
              LinearProgressIndicator(value : progressPercent),
              Text(
                '${(progressPercent * 100).toStringAsFixed(2)}% '
              ),
            ],
          );
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



  class Meuapp extends StatefulWidget {
  @override
  _MeuappState createState() => _MeuappState();
  }

  class _MeuappState extends State<Meuapp> {
    File img;


    Future<void> _pickImage(ImageSource source) async {
      File image = await ImagePicker.pickImage(source: source);
      setState(() {
        img = image;
        ab =  12;
      });
    }

    Widget _decideImagem(){
      if(ab == 10){

        return Text("Nenhuma Imagem Selecionada");
      }
      if(ab == 12){
        return Image.file(img, width: 400,height: 400,);
      }
    }



    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Doggo'),
            centerTitle: true,
            backgroundColor: Colors.orange[600],
          ),
          body:Container(
            child:Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(child: _decideImagem()),
                    Uploader(file: img)
                  ],
                )
            )

          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  color: Colors.orange[600],
                  icon: Icon(Icons.camera),
                  onPressed: () => _pickImage(ImageSource.camera)
                ),
                IconButton(
                  color: Colors.orange[600],
                  icon: Icon(Icons.wallpaper),
                  onPressed: () => _pickImage(ImageSource.gallery)
                ),

              ],
            )
          ),
        ),
      );


    }

    void clear() {

    }
  }
