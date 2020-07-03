import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class DetailPet extends StatelessWidget {
  final int pet;
  final db = Firestore.instance;
  GoogleMapController mapController;
  DetailPet(this.pet);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[600],
          elevation:0.0,
          title: Text('Doggo'),
        ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0, 0.5),
            end: Alignment(1, 0.5),
            colors: [Color(0xffebbd57), Color(0xffeb6e57)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 318,
              height: 520,
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
              child: FutureBuilder(
                  future: getPet(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return new Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      Timestamp t = snapshot.data[pet].data["data"];
                      DocumentSnapshot ds = snapshot.data[pet];
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 130.0,
                                      width: 80.0,
                                      child: FutureBuilder(
                                        future:
                                            _buildImage(snapshot.data[pet].data["image"]),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> image) {
                                          if (image.hasData) {
                                            return image.data; // image is ready
                                          } else {
                                            return Image.network(
                                              "https://imamt.org.br/wp-content/themes/imamt/images/notfound.png",
                                              fit: BoxFit.cover,
                                            ); // placeholder
                                          }
                                        },
                                      ),
                                    ),
                                    Text(snapshot.data[pet].data["raca"].toString()),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(snapshot.data[pet].data["description"].toString()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(snapshot.data[pet].data["local"].toString()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: snapshot.data[pet].data["perdido"] == true ? Text('Status: Perdido', style: TextStyle(color: Colors.redAccent),) : Text('Status: Resgatado', style: TextStyle(color: Colors.blueAccent),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Cadastrado em: ${DateFormat("dd-MM-yyyy - kk:mm").format(DateTime.parse(t.toDate().toString()))}'),
                              ),
                              snapshot.data[pet].data["perdido"] == true ? Container(
                                width: 150,
                                child: RaisedButton(
                                  onPressed:() async {
                                    await db.collection('Pet').document(ds.documentID).updateData({'perdido': false});
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
                                        'Resgatar Doggo',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              : Text('')
                              ,
                            ],
                          ),
                        ),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future getPet() async {

    QuerySnapshot qn = await db.collection("Pet").getDocuments();

    return qn.documents;
  }

  _buildImage(name) async {
    final ref = FirebaseStorage.instance.ref().child('pets/$name.jpg');
// no need of the file extension, the name will do fine.
    var url = await ref.getDownloadURL();
    return Image.network(
      url,
      fit: BoxFit.cover,
    );
  }
}
