import 'package:flutter/material.dart';
import 'package:flutter_final/home.dart';

class TabeMenuPage extends StatefulWidget {
  final String username;
  final String avatar;
  const TabeMenuPage({Key? key, required this.username, required this.avatar})
      : super(key: key);

  @override
  _TabeMenuPageState createState() => _TabeMenuPageState();
}

class _TabeMenuPageState extends State<TabeMenuPage> {
  late String _username;
  late String _avatar;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _username = widget.username;
    _avatar = widget.avatar;
  }

  void _logout() {
    Navigator.pop(context);
  }

  List<Widget> _widgetOptions() {
    return <Widget>[
      Homegame(),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_avatar),
            ),
            SizedBox(height: 20),
            Text(
              _username,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _logout, child: const Text('Logout'))
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          automaticallyImplyLeading: false,
        ),
      ),
      body: Center(
        child: _widgetOptions().elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromARGB(255, 231, 11, 11),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
