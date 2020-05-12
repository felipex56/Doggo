import 'package:doggo/autentication/login.dart';
import 'package:doggo/autentication/registro.dart';
import 'package:doggo/autentication/LoginNew.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showLoginApp = true;
  void toggleView(){
    setState(() => showLoginApp = !showLoginApp);
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginApp){
      return Login(toggleView: toggleView);
    }else{
      return Register(toggleView: toggleView);
    }
    return Container(
      child: Register(),
    );
  }
}