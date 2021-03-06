
import 'package:doggo/telas/InitPage.dart';
import 'package:doggo/telas/home2.dart';
import 'package:doggo/telas/profile.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
class WidgetBBar extends StatefulWidget {
  @override
  _WidgetBBarState createState() => _WidgetBBarState();
}

class _WidgetBBarState extends State<WidgetBBar> {
  int _selectedIndex = globals.selectedIndex;
  bool active = true;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Perfil',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {

    print("Esse é o index antes do state ${globals.selectedIndex}");

    setState(() {
      _selectedIndex = index;
      globals.selectedIndex = _selectedIndex;
    });

    print("Esse é o index depois do state ${globals.selectedIndex}");

    if(index == 0){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage()
        ),
      );
    }
    if(index == 1){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Profile()
        ),
      );
    }

//    if(index == 0 && active == false){
//      active = true;
//      Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => HomePage()
//        ),
//      );
//    }
//    if(index == 1 && active == true){
//      active = false;
//      Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => Profile()
//        ),
//      );
//    }
  }
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Perfil'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      );


  }
}
