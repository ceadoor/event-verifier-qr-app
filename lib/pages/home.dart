import 'package:flutter/material.dart';

import 'pages.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;
  List<Widget> _pages = <Widget>[ScanQR(),ListStudents()];

  void _onItemTapped(int index)
  {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hacktoberfest Event"),),
      body: Layout(child: _pages.elementAt(_selectedIndex),),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:Icon(Icons.code),
            title: Text('Scan QR')
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.code),
            title: Text('List Students')
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Layout extends StatelessWidget {
  
  final Widget child;
  Layout({Key key, @required this.child}): super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: this.child,
    );
  }
}