import 'package:flutter/material.dart';
import 'package:mobilink_v2/UI/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: 40, left: 16), // Atur padding sesuai kebutuhan
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
                  icon: Icons.notifications,
                  title: 'Pemberitahuan',
                  onTap: () {},
                ),
                Divider(),
                _buildMenuItem(
                  icon: Icons.language,
                  title: 'Bahasa',
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
                  icon: Icons.headset_mic,
                  title: 'Dukungan pelanggan',
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
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 40.0,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Cameron Williamson',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                '(219) 555-0114',
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
