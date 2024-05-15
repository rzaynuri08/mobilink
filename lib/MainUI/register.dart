import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  final List<String> genders = ['Male', 'Female'];
  String selectedGender = 'Male';

  final _formKey = GlobalKey<FormState>();

  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('fullName', _fullNameController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setString('gender', selectedGender);

      // Prepare data for API request
      Map<String, dynamic> userData = {
        "username_mb": _usernameController.text,
        "password": _passwordController.text,
        "nama": _fullNameController.text,
        "email": "rzaynuri@gmail.com",
        "nomor_hp_user": "08924634854",
        "tgl_lahir": "2003-07-30",
        "domisili": "Bondowoso"
      };

      // Send registration data to API
      try {
        Uri url = Uri.parse('https://mobilinkqz.my.id/api/billy123/users');
        final response = await http.post(
          url,
          body: json.encode(userData),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          // Registration successful, navigate to login screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          // Handle error
          print('Failed to register: ${response.reasonPhrase}');
          // You can display an error message to the user
        }
      } catch (error) {
        print('Error: $error');
        // Handle error
        // You can display an error message to the user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama lengkap harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedGender,
                onChanged: (newValue) {
                  selectedGender = newValue!;
                },
                items: genders.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                child: Text('Register'),
                onPressed: () => _register(context),
              ),
              TextButton(
                child: Text('Already have an account? Login'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
