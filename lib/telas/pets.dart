import 'package:doggo/telas/widgetBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';


void main() => runApp(new MyPetPage());

class MyPetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyPet(),
    );
  }
}

class MyPet extends StatefulWidget {
  @override
  _MyPetState createState() => _MyPetState();
}

class _MyPetState extends State<MyPet> {
  List items = getDummyList();

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
        child: Center(
          child: Container(
            width: 330,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                    elevation: 5,
                    child: Container(
                      height: 100.0,
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 100.0,
                            width: 70.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    topLeft: Radius.circular(5)),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        "https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png"))),
                          ),
                          Container(
                            height: 100,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    items[index],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                    child: Container(
                                      width: 75,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.deepOrange),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Text(
                                        "Perdido",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                                    child: Container(
                                      child: Text(
                                        "Praça Sete - Centro, Belo Horizonte",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color.fromARGB(
                                                255, 48, 48, 54)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: WidgetBBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(),
          );
        },
        backgroundColor: Color(0xffeb6e57),
        child: Icon(Icons.add_location),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  static List getDummyList() {
    List list = List.generate(10, (i) {
      return "american staffordshire terrier ${i + 1}";
    });
    return list;
  }
}

/*Container(
        decoration: BoxDecoration(color: const Color(0xFFeeeeee)),
        child: Center(child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),*/
