import 'dart:async';
import 'dart:io';
import 'package:doggo/autentication/autenteicacao.dart';
import 'package:doggo/home/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:tflite/tflite.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:doggo/models/user.dart';

int ab = 10 ;
int c = 12 ;
int cont = 10;


void main() async{
  runApp(MyNewApp());
}

  class MyNewApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(
          home: Wrapper(),
        ),
      );
    }
  }
