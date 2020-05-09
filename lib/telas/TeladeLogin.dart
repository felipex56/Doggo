import 'package:doggo/LoginNew.dart';
import 'package:flutter/material.dart';

void main() => runApp(new TelaLogin());

class TelaLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TeladeLogin(),
    );
  }
}


class TeladeLogin extends StatefulWidget {
  @override
  _TeladeLoginState createState() => _TeladeLoginState();
}

class _TeladeLoginState extends State<TeladeLogin> {
  @override
  Widget build(BuildContext context) {
    return LoginApp();
  }
}