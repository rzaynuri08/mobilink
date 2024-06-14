import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobilink_v2/UI/dashboard.dart';
import 'package:mobilink_v2/utills/constants.dart';
import 'package:mobilink_v2/API/ApiService.dart';
import 'package:mobilink_v2/Modal/PaymentModel.dart';

class UploadPage extends StatefulWidget {
  final String message;
  final String selectedPaymentIdJenis;

  UploadPage({required this.message, required this.selectedPaymentIdJenis});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _image;
  final picker = ImagePicker();
  late String id_transaksi;
  late String IdJenis;
  Payment? paymentMethod;

  @override
  void initState() {
    super.initState();
    id_transaksi = widget.message;
    IdJenis = widget.selectedPaymentIdJenis;
    print('Message from previous page: ${widget.message}');
    print(IdJenis);
    fetchPaymentMethod();
  }

  Future fetchPaymentMethod() async {
    try {
      Payment payment = await ApiService().fetchPaymentMethodByID(IdJenis);
      setState(() {
        paymentMethod = payment;
      });
    } catch (e) {
      print('Failed to fetch payment method: $e');
    }
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
    request.fields['id_transaksi'] = id_transaksi; // Add transaction ID to the request
    request.files.add(await http.MultipartFile.fromPath('bukti_pembayaran', image.path)); // Change the field name to 'bukti_pembayaran'
    
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardScreen(),
                    ),
                  );
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (paymentMethod != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Image.network(
                      "https://mobilink.my.id/${paymentMethod!.logo}",
                      height: 50,
                      width: 50,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      paymentMethod!.namaPembayaran,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${paymentMethod!.noRek}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.copy),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: paymentMethod!.noRek));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Nomor rekening disalin ke clipboard'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
            child: Text('Kirim Sekarang', style: TextStyle(color: Colors.white)),
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
