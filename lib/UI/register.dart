import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _domicileController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? _ageError;

  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState!.validate() && _isOldEnough()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('fullName', _fullNameController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setString('email', _emailController.text);
      await prefs.setString('phoneNumber', _phoneNumberController.text);
      await prefs.setString('domicile', _domicileController.text);
      await prefs.setString('dateOfBirth', _dateOfBirthController.text);

      // Prepare data for API request
      Map<String, dynamic> userData = {
        "username_mb": _usernameController.text,
        "password": _passwordController.text,
        "nama": _fullNameController.text,
        "email": _emailController.text,
        "nomor_hp_user": _phoneNumberController.text,
        "tgl_lahir": _dateOfBirthController.text,
        "domisili": _domicileController.text,
      };

      // Send registration data to API
      try {
        Uri url = Uri.parse('https://mobilinkqz.my.id/api/billy123/users');
        await http.post(
          url,
          body: json.encode(userData),
          headers: {'Content-Type': 'application/json'},
        );

        // Registration successful, navigate to login screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } catch (error) {
        print('Error: $error');
        // Handle error
        // You can display an error message to the user
      }
    }
  }

  bool _isOldEnough() {
    if (_dateOfBirthController.text.isEmpty) {
      return false;
    }
    DateTime dob = DateTime.parse(_dateOfBirthController.text);
    DateTime today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    if (age < 18) {
      setState(() {
        _ageError = 'Umur harus minimal 18 tahun';
      });
      return false;
    }
    setState(() {
      _ageError = null;
    });
    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _dateOfBirthController.text = selectedDate.toLocal().toString().split(' ')[0];
      });
      _isOldEnough();
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
          child: SingleChildScrollView(
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
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email harus diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon harus diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _dateOfBirthController,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _selectDate(context);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal lahir harus diisi';
                    }
                    return null;
                  },
                ),
                if (_ageError != null) ...[
                  SizedBox(height: 8.0),
                  Text(
                    _ageError!,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _domicileController,
                  decoration: InputDecoration(
                    labelText: 'Domicile',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Domisili harus diisi';
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
                SizedBox(height: 24.0),
                ElevatedButton(
                  child: Text('Register'),
                  onPressed: () => _register(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
