import 'package:flutter/material.dart';
import 'package:mobilink_v2/API/ApiService.dart';
import 'package:mobilink_v2/Modal/Transaction.dart';
import 'package:mobilink_v2/utills/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilink_v2/UI/ViewDetailTransaction.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  String dropdownValue = 'Semua'; // default dropdown value
  late List<TransactionHistory> transactions = [];
  late String usernameMb = '';

  @override
  void initState() {
    super.initState();
    fetchData();
    _getUsernameMb();
  }

  void _getUsernameMb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usernameMb = prefs.getString('username_mb') ?? ''; // get username from SharedPreferences
    });
  }

  void fetchData() async {
    try {
      // Fetch data based on dropdown value
      if (dropdownValue == 'Semua') {
        transactions = await ApiService().fetchTransactions(usernameMb);
      } else if (dropdownValue == 'Belum Dibayar') {
        transactions = await ApiService().fetchTransactions(usernameMb, status: 0);
      } else if (dropdownValue == 'Pending') {
        transactions = await ApiService().fetchTransactions(usernameMb, status: 1);
      } else if (dropdownValue == 'Berhasil') {
        transactions = await ApiService().fetchTransactions(usernameMb, status: 2);
      } else if (dropdownValue == 'Ditolak') {
        transactions = await ApiService().fetchTransactions(usernameMb, status: 3);
      }
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case '0':
        return 'Belum Dibayar';
      case '1':
        return 'Pending';
      case '2':
        return 'Berhasil';
      case '3':
        return 'Ditolak';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[100], // Set background color to grey[100]
        body: Padding(
          padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Riwayat Transaksi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                    fetchData();
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kPrimaryColor, // Set background color to blue
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white, // Set text color to white
                ),
                dropdownColor: Colors.blue, // Set dropdown menu background color to blue
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white, // Set dropdown arrow color to white
                ),
                items: <String>['Semua', 'Belum Dibayar', 'Menunggu Persetujuan', 'Berhasil', 'Ditolak']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.white, // Set menu item text color to white
                      ),
                    ),
                  );
                }).toList(),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewDetailTransaction(transaction: transactions[index]),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.white, // Set card color to white
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              "https://mobilink.my.id/${transactions[index].foto_mobil}",
                              width: 100, // Lebar gambar
                              height: 100, // Tinggi gambar
                            ),
                            SizedBox(width: 12), // Memberikan jarak antara gambar dan teks
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${transactions[index].nama_mobil} ${transactions[index].tipe}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(transactions[index].nama_toko),
                              ],
                            ),
                            SizedBox(width: 12), // Memberikan jarak antara teks nama mobil dan tanggal transaksi
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(height: 4),
                                  Text(
                                    getStatusText(transactions[index].status),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
