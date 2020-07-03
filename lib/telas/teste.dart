import 'package:flutter/material.dart';

void main() => runApp(new testeee());

class testeee extends StatefulWidget {
  @override
  _testeeeState createState() => _testeeeState();
}

class _testeeeState extends State<testeee> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.amber,
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              width: 50,
              height: 50,
              child: ClipOval(
                child: Image.network(
                  "https://imamt.org.br/wp-content/themes/imamt/images/notfound.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            RaisedButton(
              child: const Text('Close BottomSheet'),
            ),
          ],
        ),
      ),
    );
  }
}
