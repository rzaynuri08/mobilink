import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mobilink_v2/Modal/car.dart';
import 'package:mobilink_v2/Shared/number_to_words.dart';
import 'package:mobilink_v2/UI/PaymentDialog.dart';
import 'package:mobilink_v2/UI/UploadPage.dart';
import 'package:mobilink_v2/utills/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilink_v2/Modal/PaymentModel.dart';
import 'package:mobilink_v2/API/ApiService.dart';
import 'package:mobilink_v2/Modal/booking.dart';

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
  String paymentMethodText = 'Metode Pembayaran';
  String? _selectedPaymentIdJenis;
  List<Booking> _bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      List<Booking> bookings = await ApiService().fetchBookings(widget.car.idMobil);
      setState(() {
        _bookings = bookings;
      });
    } catch (e) {
      print('Failed to load bookings: $e');
    }
  }

  bool _isDateRangeAvailable(DateTimeRange range) {
    for (Booking booking in _bookings) {
      if (range.start.isBefore(booking.tanggal_akhir) &&
          range.end.isAfter(booking.tanggal_mulai)) {
        return false;
      }
    }
    return true;
  }

  int _calculateTotalPayment() {
    if (_selectedDateRange != null) {
      int days = _selectedDateRange!.end.difference(_selectedDateRange!.start).inDays;
      int pricePerDay = int.parse(widget.car.hargaSewaPerhari);
      return days * pricePerDay;
    }
    return 0;
  }

  Future<void> _sendBookingData() async {
    if (_selectedDateRange == null) {
      // Show a message to select a date range
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date range')),
      );
      return;
    }

    String username = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username') ?? '';

    Map<String, dynamic> bookingData = {
      'total': _calculateTotalPayment(),
      'username': widget.car.username,
      'username_mb': username,
      'id_mobil': widget.car.idMobil,
      'id_jenis': _selectedPaymentIdJenis ?? '',
      'tanggal_mulai': DateFormat('yyyy-MM-dd').format(_selectedDateRange!.start).toString(),
      'tanggal_akhir': DateFormat('yyyy-MM-dd').format(_selectedDateRange!.end).toString(),
      'tipe_bayar': _selectedPaymentMethod == PaymentMethod.bayarLangsung ? 0 : 1,
    };

    print('Data Pemesanan:');
    print(bookingData);

    try {
      final response = await http.post(
        Uri.parse('https://mobilink.my.id/api/billy123/transaksi'),
        body: json.encode(bookingData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var responseData = json.decode(response.body);
      var message = responseData['message'];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadPage(message: message),
        ),
      );
      print('$message');
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPayment = _calculateTotalPayment();
    String totalPaymentInWords = numberToWords(totalPayment);

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
                        if (_isDateRangeAvailable(pickedDateRange)) {
                          setState(() {
                            _selectedDateRange = pickedDateRange;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Tanggal tersebut sudah di booking')),
                          );
                        }
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
                        : 'Pilih tanggal terlebih dahulu',
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
            SizedBox(height: 30),
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
                  Text(paymentMethodText),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => PaymentSelectionDialog(paymentService: ApiService()),
                      ).then((selectedPayment) {
                        if (selectedPayment != null) {
                          setState(() {
                            paymentMethodText = selectedPayment.namaPembayaran;
                            _selectedPaymentIdJenis = selectedPayment.idJenis;
                          });
                        }
                      });
                    },
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
            onPressed: _sendBookingData,
            child: Text(
              'Pesan Sekarang',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
