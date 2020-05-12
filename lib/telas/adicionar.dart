import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doggo/telas/pets.dart';
import 'package:flutter/material.dart';
import 'package:doggo/telas/widgetBar.dart';

void main() => runApp(new LoginPage());

class LoginPage extends StatelessWidget {
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

class _AddPetState extends State<AddPet> {
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String local;
  String raca;
  String description;

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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            onTap: (){

                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                "assets/img/dogg.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: 172,
                                child: TextFormField(
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
                              )
                            ],
                          )
                        ],
                      ),
                      Container(
                        width: 272,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Raça",
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Preencha a Raça.';
                            }
                            return null;
                          },
                          onSaved: (value) => raca = value,
                        ),
                      ),
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
      bottomNavigationBar: WidgetBBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: createData,
        child: Icon(Icons.save),
      ),
    );
  }
  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection('Pet').add({'local': '$local', 'raca': '$raca', 'description': '$description', 'perdido': true});
      setState(() => id = ref.documentID);
      print(ref.documentID);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyPetPage()
      ),
    );
  }
}
