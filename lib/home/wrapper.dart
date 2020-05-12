import 'package:doggo/autentication/autenticate.dart';
import 'package:doggo/telas/adicionar.dart';
import 'package:flutter/material.dart';
import 'package:doggo/autentication/autenteicacao.dart';
import 'package:doggo/autentication/login.dart';
//import 'package:doggo/telas/home2.dart';
import 'package:provider/provider.dart';
import 'package:doggo/models/user.dart';
import 'package:doggo/telas/InitPage.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);


    if (user == null){
      return Authenticate();
    }else{
      return HomePage();
    }
  }
}

