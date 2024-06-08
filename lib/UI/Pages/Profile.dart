import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilink_v2/UI/login.dart';
import 'package:mobilink_v2/Modal/user.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    if (username != null) {
      Uri url = Uri.parse('https://mobilink.my.id/api/billy123/users');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> usersData = json.decode(response.body);
        final userData = usersData.firstWhere((user) => user['username_mb'] == username);

        setState(() {
          user = User.fromJson(userData);
          isLoading = false;
        });
      } else {
        // Handle server error
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // Handle user not found in shared preferences
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 50, left: 16),
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      _buildProfileHeader(),
                      _buildMenuItem(
                        icon: Icons.person,
                        title: 'Sunting Profil',
                        onTap: () {},
                      ),
                      Divider(),
                      _buildMenuItem(
                        icon: Icons.shopping_cart,
                        title: 'Pemesanan saya',
                        onTap: () {},
                      ),
                      Divider(),
                      _buildMenuItem(
                        icon: Icons.settings,
                        title: 'Pengaturan aplikasi',
                        onTap: () {},
                      ),
                      Divider(),
                      _buildMenuItem(
                        icon: Icons.info_outline,
                        title: 'Syarat dan Kondisi',
                        onTap: () {},
                      ),
                      Divider(),
                      _buildMenuItem(
                        icon: Icons.star,
                        title: 'Nilai kami',
                        onTap: () {},
                      ),
                      Divider(),
                      _buildMenuItem(
                        icon: Icons.exit_to_app,
                        title: 'Keluar',
                        textColor: Colors.red,
                        onTap: () {
                          showDialog(
                            context: context,
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
                                      _logout(context);
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
                        },
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildProfileHeader() {
    if (user == null) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 40.0,
            backgroundImage: user!.foto_profil != null
                ? NetworkImage("https://mobilink.my.id/${user!.foto_profil!}")
                : AssetImage('https://mobilink.my.id/') as ImageProvider,
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user!.name,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                user!.phoneNumber,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color textColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('username'); // Clear username from shared preferences
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}

