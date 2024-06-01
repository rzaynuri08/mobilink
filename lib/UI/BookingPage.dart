import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobilink_v2/Modal/car.dart';
import 'package:mobilink_v2/utills/constants.dart';

enum PaymentMethod { bayarLangsung, bayarDP }

class BookingPage extends StatefulWidget {
  final CarModel car;

  BookingPage({required this.car});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTimeRange? _selectedDateRange;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.bayarLangsung;

  int _calculateTotalPayment() {
    if (_selectedDateRange != null) {
      int days = _selectedDateRange!.end.difference(_selectedDateRange!.start).inDays;
      int pricePerDay = int.parse(widget.car.hargaSewaPerhari);
      return days * pricePerDay;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    int totalPayment = _calculateTotalPayment();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pesan'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.network(
                      "https://mobilink.my.id/${widget.car.foto_mobil}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.car.namaMobil,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.car.tipe,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Rp. ${widget.car.hargaSewaPerhari} /hari",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedDateRange != null
                      ? '${_selectedDateRange!.end.difference(_selectedDateRange!.start).inDays} hari'
                      : 'Durasi pemesanan'),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTimeRange? pickedDateRange = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDateRange != null) {
                        setState(() {
                          _selectedDateRange = pickedDateRange;
                        });
                      }
                    },
                    child: Text(
                      'Pilih Tanggal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      textStyle: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDateRange != null
                        ? '${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.end)}'
                        : 'Tanggal pemesanan',
                  ),
                  Text(
                    'Tanggal',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rp. $totalPayment',
                  ),
                  Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Metode Pembayaran'),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Pilih Pembayaran',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      textStyle: TextStyle(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<PaymentMethod>(
                    value: _selectedPaymentMethod,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedPaymentMethod = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: 'Metode Pembayaran',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    items: PaymentMethod.values.map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(
                          method == PaymentMethod.bayarLangsung ? 'Bayar Langsung' : 'Bayar DP dulu',
                        ),
                      );
                    }).toList(),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  if (_selectedPaymentMethod == PaymentMethod.bayarDP)
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        '* Pembayaran DP minimal 20 ribu',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // Tambahkan logika untuk tombol "Pesan Sekarang" di sini
              // Misalnya, navigasi ke halaman pembayaran atau tindakan lainnya.
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              elevation: 0,
            ),
            child: Text(
              'Pesan Sekarang',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
