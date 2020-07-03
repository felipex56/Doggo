import 'package:doggo/telas/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doggo/models/user.dart';
import 'package:flutter/foundation.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //criar objeto de usuario baseado em firebaseuser
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }

  //autenticacao change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }




  //logar anonimo
  Future signInAnon() async{
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //logar email e senha

  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      globals.email = user.email;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;

    }
  }





  //registrar email e senha
  Future createUserWithEmailAndPassword(String email, String password, String nome) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password,);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;

    }
  }

  //deslogar
  Future signOut() async{
    try{
      await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;

    }
  }







}