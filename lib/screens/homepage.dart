import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prominent/firebase/auth.dart';
import 'package:prominent/screens/register_project.dart';
import 'package:prominent/screens/project_list.dart';
import 'package:prominent/screens/setting.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    ProjecList(),
    RegisterProject(),
    Setting(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.checklist), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.add_task), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'Settings')
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
