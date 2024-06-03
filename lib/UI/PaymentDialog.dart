import 'package:flutter/material.dart';
import 'package:mobilink_v2/Modal/PaymentModel.dart';
import 'package:mobilink_v2/API/ApiService.dart';

class PaymentSelectionDialog extends StatelessWidget {
  final ApiService paymentService;

  PaymentSelectionDialog({required this.paymentService});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pilih Pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            FutureBuilder<List<Payment>>(
              future: paymentService.fetchPaymentMethod(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Payment payment = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: Image.network(
                            "https://mobilink.my.id/${payment.logo}",
                            width: 50,
                          ),
                          title: Text(payment.namaPembayaran),
                          onTap: () {
                            Navigator.pop(context, payment);
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return Text('No data available');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
