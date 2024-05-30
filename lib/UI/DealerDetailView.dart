import 'package:flutter/material.dart';
import 'package:mobilink_v2/Modal/mitra.dart';

class DealerDetailView extends StatelessWidget {
  final Dealer dealer;

  DealerDetailView({required this.dealer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dealer Detail"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dealer Name: ${dealer.namaToko}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Owner: ${dealer.namaLengkap}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Address: ${dealer.latitude}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Phone: ${dealer.longitude}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Email: ${dealer.nomorHp}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
