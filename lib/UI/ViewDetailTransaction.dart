import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobilink_v2/Modal/Transaction.dart';
import 'package:mobilink_v2/UI/UploadPage.dart';
import 'package:mobilink_v2/utills/constants.dart';

class ViewDetailTransaction extends StatelessWidget {
  final TransactionHistory transaction;

  ViewDetailTransaction({required this.transaction});

  @override
  Widget build(BuildContext context) {
    DateTime startDate = DateTime.parse(transaction.tanggalMulai);
    DateTime endDate = DateTime.parse(transaction.tanggalAkhir);
    Duration duration = endDate.difference(startDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Transaksi'),
      ),
      body: Container(
        key: UniqueKey(),
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    "https://mobilink.my.id/${transaction.foto_mobil}",
                    width: null,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.nama_mobil ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      SizedBox(height: 8),
                      Text(
                        getStatusText(transaction.status),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    transaction.idTransaksi,
                  ),
                  Text(
                    'Kode Transaksi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${DateFormat('dd MMMM yyyy').format(startDate)} - ${DateFormat('dd MMMM yyyy').format(endDate)}",
                  ),
                  Text(
                    'Tanggal sewa',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${duration.inDays.toString()} hari",
                  ),
                  Text(
                    'Durasi Sewa',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${transaction.total}',
                  ),
                  Text(
                    'Total',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${transaction.namaPembayaran}',
                  ),
                  Text(
                    'Pembayaran',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (transaction.status == '0')
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: ElevatedButton(
                        onPressed: () {
                            Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => UploadPage(message : transaction.idTransaksi, selectedPaymentIdJenis: transaction.idJenis,)),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16.0), // Menambahkan padding di dalam button
                          child: Text(
                            'Bayar Sekarang',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 0),
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Mengurangi rounding pada sudut
                          ),
                        ),
                      ),
                    ),
                  if (transaction.status == '1')
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Text(
                        'MENUNGGU PERSETUJUAN',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (transaction.status == '2')
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Text(
                        'TRANSAKSI BERHASIL',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (transaction.status == '3')
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Text(
                        'TRANSAKSI DITOLAK',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getStatusText(String status) {
    switch (status) {
      case '0':
        return 'Belum Dibayar';
      case '1':
        return 'Menunggu Persetujuan';
      case '2':
        return 'Berhasil';
      case '3':
        return 'Ditolak';
      default:
        return 'Status Tidak Dikenali';
    }
  }
}
