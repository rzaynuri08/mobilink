import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobilink_v2/Modal/booking.dart';
import 'package:mobilink_v2/utills/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderViewDetail extends StatelessWidget {
  final Booking booking;

  OrderViewDetail({required this.booking});

  @override
  Widget build(BuildContext context) {
    final double latitude = booking.latitude;
    final double longitude = booking.longitude;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pesanan'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Add padding here
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.namaMobil,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  booking.tipe,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Center(
                  child: Image.network(
                    "https://mobilink.my.id/${booking.fotoMobil}",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Status: ${booking.status}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StatusMessage(status: booking.status, booking: booking),
                SizedBox(height: 20),
                StatusProgressIndicator(status: booking.status),
                SizedBox(height: 20),
                Text(
                            "Maps",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 18),
                          _buildMapCard(latitude, longitude),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatusProgressIndicator extends StatelessWidget {
  final String status;

  StatusProgressIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    Map<String, int> statusToProgress = {
      'Belum Diambil': 0,
      'Sedang Disewa': 1,
      'Belum Dikembalikan': 2,
      'Sudah Dikembalikan': 3,
    };

    int currentProgress = statusToProgress[status] ?? 0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProgressStep(
              isActive: currentProgress >= 0,
              icon: Icons.payment,
            ),
            ProgressLine(isActive: currentProgress >= 1),
            ProgressStep(
              isActive: currentProgress >= 1,
              icon: Icons.car_rental,
            ),
            ProgressLine(isActive: currentProgress >= 2),
            ProgressStep(
              isActive: currentProgress >= 2,
              icon: Icons.assignment_returned,
            ),
            ProgressLine(isActive: currentProgress >= 3),
            ProgressStep(
              isActive: currentProgress >= 3,
              icon: Icons.check,
            ),
          ],
        ),
      ],
    );
  }
}

class ProgressStep extends StatelessWidget {
  final bool isActive;
  final IconData icon;

  ProgressStep({required this.isActive, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? kPrimaryColor : Colors.grey,
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class ProgressLine extends StatefulWidget {
  final bool isActive;

  ProgressLine({required this.isActive});

  @override
  _ProgressLineState createState() => _ProgressLineState();
}

class _ProgressLineState extends State<ProgressLine> {
  bool _isBlinking = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    if (widget.isActive) {
      _startBlinking();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startBlinking() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _isBlinking = !_isBlinking;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: 4.0,
            margin: EdgeInsets.symmetric(horizontal: 2.0),
            decoration: BoxDecoration(
              color: _isBlinking && widget.isActive ? kPrimaryColor : Colors.grey,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildMapCard(double latitude, double longitude) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        height: 200,
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(latitude, longitude),
            zoom: 15.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(latitude, longitude),
                  width: 80,
                  height: 80,
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

class StatusMessage extends StatelessWidget {
  final String status;
  final Booking booking;

  StatusMessage({required this.status, required this.booking});

  @override
  Widget build(BuildContext context) {
    String message;

    if (status == 'Belum Diambil') {
      message = 'Pembayaran berhasil, ambil mobil pada tanggal ${DateFormat('dd MMMM yyyy').format(booking.tanggal_mulai)}';
    } else if (status == 'Sedang Disewa') {
      message = 'Mobil sudah diambil oleh pelanggan. Kamu bisa mengembalikan mobil pada ${DateFormat('dd MMMM yyyy').format(booking.tanggal_akhir)}';
    } else if (status == 'Belum Dikembalikan') {
      message = 'Mobil belum dikembalikan oleh pelanggan.';
    } else if (status == 'Sudah Dikembalikan') {
      message = 'Mobil sudah dikembalikan dan pemesanan selesai.';
    } else {
      message = 'Status pesanan tidak diketahui.';
    }

    return Text(
      message,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[700],
      ),
    );
  }
}
