import 'package:doggo/autentication/login.dart';
import 'package:doggo/autentication/registro.dart';
import 'package:doggo/LoginNew.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool mostrarSignIn = true;
  void toggleView(){
    setState(() => mostrarSignIn = !mostrarSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if(mostrarSignIn){
      return LoginApp(toggleView: toggleView);
    }else{
      return Register(toggleView: toggleView);
    }
    return Container(
      child: Register(),
    );
  }
}