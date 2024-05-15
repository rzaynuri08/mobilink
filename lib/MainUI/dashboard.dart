import 'package:flutter/material.dart';
import 'package:mobilink_v2/MainUI/coba.dart';
import 'package:mobilink_v2/utills/car_widget.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilink_v2/MainUI/discover.dart';
import 'package:mobilink_v2/MainUI/coba.dart';
import 'package:mobilink_v2/API/ApiService.dart';
import 'package:mobilink_v2/Modal/car.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<String> _menuTitles = [
    'Dashboard',
    'Event',
    'Profile',
  ];

  final List<IconData> _menuIcons = [
    Icons.home,
    Icons.calendar_today,
    Icons.person,
  ];

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah Anda ingin logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Iya'),
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
            TextButton(
              child: Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _getSelectedPage() {
      switch (_selectedIndex) {
        case 0:
          return Showroom();
        case 1:
          return FutureBuilder<List<CarModel>>(
    future: ApiService().fetchCars(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        List<CarModel> cars = snapshot.data ?? [];
        return CarListView(cars: cars);
      }
    },
  );
        case 2:
          return Center(
            child: Text(
              'Profile',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          );
        default:
          return Center(
            child: Text(
              'Dashboard',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Mobilink'),
        centerTitle: true,
        automaticallyImplyLeading: true, // Menampilkan ikon hamburger untuk membuka Drawer
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            for (int i = 0; i < 3; i++) // Adjusted loop to match the menu items
              ListTile(
                title: Text(_menuTitles[i]),
                leading: Icon(_menuIcons[i]),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedIndex = i;
                  });
                },
              ),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog();
              },
            ),
          ],
        ),
      ),
      body: _getSelectedPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Event',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
