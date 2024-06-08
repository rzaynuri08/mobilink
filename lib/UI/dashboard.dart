import 'package:flutter/material.dart';
import 'package:mobilink_v2/UI/Pages/Chats.dart';
import 'package:mobilink_v2/UI/Pages/Profile.dart';
import 'package:mobilink_v2/UI/Pages/Discover.dart';
import 'package:mobilink_v2/UI/Pages/order.dart';
import 'package:mobilink_v2/utills/constants.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilink_v2/API/ApiService.dart';
import 'package:mobilink_v2/Modal/car.dart';
import 'package:mobilink_v2/UI/Pages/transaction.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

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

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return FutureBuilder<List<CarModel>>(
          future: ApiService().fetchCars(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<CarModel> cars = snapshot.data?? [];
              return CarListView(cars: cars);
            }
          },
        );
      case 1:
        return OrderPage();
      case 2:
        return TransactionPage();
      case 3:
        return ProfileScreen();
      default:
        return Center(
          child: Text(
            'Dashboard',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _getSelectedPage(),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, -1),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            color: Colors.transparent,
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: _selectedIndex == 0
                     ? Container(
                          padding: EdgeInsets.all(0.0),
                          child: Icon(Icons.home, color: kPrimaryColor),
                        )
                      : Icon(Icons.home),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.car_rental),
                  label: 'Pesanan Saya',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'Riwayat Transaksi',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: kPrimaryColor,
              unselectedItemColor: Colors.black,
              onTap: _onItemTapped,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
            ),
          ),
        ),
      ),
    );
  }
}