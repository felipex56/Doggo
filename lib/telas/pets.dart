import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doggo/telas/adicionar.dart';
import 'package:doggo/telas/detailPet.dart';
import 'package:doggo/telas/widgetBar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

//void main() => runApp(new MyPetPage());

class MyPetPage extends StatelessWidget {
  List items = getDummyList();

  Future getClientes() async {
    final db = Firestore.instance;

    QuerySnapshot qn = await db.collection("Pet").getDocuments();

    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[600],
        elevation:0.0,
        title: Text('Pets Encontrados'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
            child: FutureBuilder(
                future: getClientes(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return new Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        return Card(
                          elevation: 5,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailPet(index)));
                            },
                            child: Container(
                              height: 130.0,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 130.0,
                                    width: 80.0,
                                    child: FutureBuilder(
                                      future: _buildImage(snapshot.data[index].data["image"]),
                                      builder: (BuildContext context, AsyncSnapshot<dynamic> image) {
                                        if (image.hasData) {
                                          return image.data;  // image is ready
                                        } else {
                                          return Image.network("https://imamt.org.br/wp-content/themes/imamt/images/notfound.png",fit: BoxFit.cover,);  // placeholder
                                        }
                                      },
                                    )
                                    ,
                                  ),
                                  Container(
                                    height: 130,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            //"nome"
                                            snapshot.data[index].data["raca"],
                                            style: TextStyle(
                                                fontSize: 20
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            EdgeInsets.fromLTRB(0, 3, 0, 3),
                                            child: Container(
                                                width: 75,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: snapshot.data[index].data["perdido"] == true ? Colors.deepOrange : Colors.blue),
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(10))),
                                                child://Text("nome")
                                                snapshot.data[index].data["perdido"] == true ? Text("Perdido", textAlign: TextAlign.center,)  : Text("Achado", textAlign: TextAlign.center)
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 2),
                                            child: Container(
                                              width: 200,
                                              child: Text(
                                                //"nome",
                                                snapshot.data[index].data["local"],
                                                textAlign: TextAlign.left,
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
                          ),
                        );
                      },
                    );
                  }
                }),
          ),
        ),
      ),
      bottomNavigationBar: WidgetBBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
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

  static List getDummyList() {
    List list = List.generate(10, (i) {
      return "american staffordshire terrier ${i + 1}";
    });
    return list;
  }

  _buildImage(name) async{
    final ref = FirebaseStorage.instance.ref().child('pets/${name}.jpg');
// no need of the file extension, the name will do fine.
    var url = await ref.getDownloadURL();
    return Image.network(url,fit: BoxFit.cover,);
  }
}

