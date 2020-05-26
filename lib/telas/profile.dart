import 'package:doggo/autentication/autenteicacao.dart';
import 'package:doggo/telas/adicionar2.dart';
import 'package:doggo/telas/pets.dart';
import 'package:doggo/telas/widgetBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

void main() => runApp(new ProfilePage());

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Profile(),
    );
  }
}

final AuthService _auth = AuthService();

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0, 0.5),
            end: Alignment(1, 0.5),
            colors: [Color(0xffebbd57), Color(0xffeb6e57)],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 90,
                    height: 90,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://i2.wp.com/geekness.com.br/wp-content/uploads/2014/07/Angelina.jpg"),
                    ),
                  ),
                  Container(
                    width: 318,
                    height: 380,
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                    child: Container(
                      width: 272,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Usuário",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "E-mail",
                            style: TextStyle(fontSize: 20),
                          ),
                          Container(
                            width: 272,
                            child: OutlineButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyPetPage()
                                  ),
                                );
                              },
                              borderSide: BorderSide(color: Color(0xffebbd57)),
                              highlightedBorderColor: Color(0xffeb6e57),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0)),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.favorite_border),
                                  Text("Pets Encontrados"),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 272,
                            height: 47,
                            child: RaisedButton(
                              onPressed:() async {
                                await _auth.signOut();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0)),
                              padding: const EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: const BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment(0, 0.5),
                                    end: Alignment(1, 0.5),
                                    colors: [
                                      Color(0xffebbd57),
                                      Color(0xffeb6e57)
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(80.0)),
                                ),
                                child: Container(
                                  constraints: const BoxConstraints(
                                      minWidth: 88.0,
                                      minHeight:
                                          36.0), // min sizes for Material buttons
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Logout',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: WidgetBBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => AddPetPage()),
          );
        },
        backgroundColor: Color(0xffeb6e57),
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
