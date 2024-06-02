import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UploadPage(),
    );
  }
}

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImage(File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.example.com/upload'),
    );
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    
    var res = await request.send();
    if (res.statusCode == 200) {
      print('Image uploaded successfully.');
      final resBody = await res.stream.bytesToString();
      final jsonResponse = json.decode(resBody);
      // Handle jsonResponse as needed
    } else {
      print('Image upload failed.');
    }
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Upload'),
          content: Text('Apakah Anda yakin ingin mengupload gambar ini?'),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Kirim Sekarang'),
              onPressed: () {
                Navigator.of(context).pop();
                uploadImage(_image!);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Bukti Pembayaran'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Image.file(_image!, height: 200),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Pilih Gambar dari Galeri'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            _image != null
                ? ElevatedButton(
                    onPressed: () => showConfirmationDialog(context),
                    child: Text('Kirim Sekarang'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
