import 'package:doggo/autentication/registro.dart';
import 'package:flutter/material.dart';

void main() => runApp(new TelaRegistro());

class TelaRegistros extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TelaRegistro(),
    );
  }
}


class TelaRegistro extends StatefulWidget {
  @override
  _TelaRegistroState createState() => _TelaRegistroState();
}

class _TelaRegistroState extends State<TelaRegistro> {
  @override
  Widget build(BuildContext context) {
    return Register();
  }
}
