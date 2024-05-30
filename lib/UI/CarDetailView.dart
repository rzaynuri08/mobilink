import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobilink_v2/Modal/car.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobilink_v2/utills/constants.dart';

class CarDetailView extends StatefulWidget {
  final CarModel car;

  CarDetailView({required this.car});

  @override
  _CarDetailViewState createState() => _CarDetailViewState();
}

class _CarDetailViewState extends State<CarDetailView> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double latitude = -7.91785;
    final double longitude = 113.83455;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 80), // Space for the fixed buttons
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.car.namaMobil,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.car.tipe,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Image.network(
                            "https://mobilink.my.id/${widget.car.foto_mobil}",
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 18),
                          Text(
                            "Specifications",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          SizedBox(
                            height: 100,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildCarInfoCard(Icons.people, 'Kapasitas', widget.car.kapasitasPenumpang, 0),
                                _buildCarInfoCard(Icons.local_gas_station, 'Bahan Bakar', widget.car.bahanBakar, 1),
                                _buildCarInfoCard(Icons.speed, 'Kecepatan', '${widget.car.kecepatan}', 2),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
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
                    ),
                  ],
                ),
              ),
            ),
            // Top bar background
            Container(
              height: 80,
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
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
                  Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Icon(
                          Icons.bookmark_border,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Container(
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
                          Icons.share,
                          color: Colors.black,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.9),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Price",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text(
                      "Rp. ${widget.car.hargaSewaPerhari}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "per day",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildBookingDialog(context);
                  },
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Book this car",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarInfoCard(IconData icon, String label, String value, int index) {
  // Daftar warna yang akan digunakan
  List<Color> cardColors = [
    Color(0xFF6126AD),
    Color(0xFFFE5598),
    Color(0xFFFFCD2D),
    Color(0xFF03C3DA),
    Colors.purple,
  ];

  return Card(
    margin: EdgeInsets.symmetric(horizontal: 4),
    shadowColor: Colors.white,
    elevation: 5,
    color: cardColors[index % cardColors.length], // Menggunakan warna bergantian dari daftar warna
    child: SizedBox(
      width: 150,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            Text(value,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
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

  Widget _buildBookingDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Book this car",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: startDateController,
              decoration: InputDecoration(
                labelText: "Start Date",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    startDateController.text = pickedDate.toLocal().toString().split(' ')[0];
                  });
                }
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: endDateController,
              decoration: InputDecoration(
                labelText: "End Date",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    endDateController.text = pickedDate.toLocal().toString().split(' ')[0];
                  });
                }
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Add your booking logic here
              },
              child: Text("Book Now"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
