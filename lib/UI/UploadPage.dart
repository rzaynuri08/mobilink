import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobilink_v2/utills/constants.dart';

class UploadPage extends StatefulWidget {
  final String message;

  UploadPage({required this.message});
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _image;
  final picker = ImagePicker();
  late String id_transaksi;

  @override
  void initState() {
    super.initState();
    id_transaksi = widget.message;  // Assume the message contains the transaction ID
    print('Message from previous page: ${widget.message}');
  }

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
      Uri.parse('https://mobilink.my.id/api/billy123/upload-bukti'),
    );
    request.fields['id_transaksi'] = id_transaksi;  // Add transaction ID to the request
    request.files.add(await http.MultipartFile.fromPath('bukti_pembayaran', image.path));  // Change the field name to 'bukti_pembayaran'
    
    var res = await request.send();
    if (res.statusCode == 200) {
      print('Image uploaded successfully.');
      final resBody = await res.stream.bytesToString();
      final jsonResponse = json.decode(resBody);
      // Handle jsonResponse as needed

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sukses'),
            content: Text('Gambar berhasil di upload.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                onPressed: getImage,
                child: _image == null
                    ? Text('Pilih Gambar dari Galeri')
                    : Image.file(_image!, height: 400, width: double.infinity, fit: BoxFit.cover),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                  minimumSize: Size(double.infinity, 400), // Make button square
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Remove rounded corners
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ElevatedButton(
            onPressed: _image != null ? () => showConfirmationDialog(context) : null,
            child: Text('Kirim Sekarang', style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor, // Set button background color to blue
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              textStyle: TextStyle(fontSize: 16),
              minimumSize: Size(double.infinity, 50), // Full width button
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Set rounded corners
            ),
          ),
        ),
      ),
    );
  }
}
