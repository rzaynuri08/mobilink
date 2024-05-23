import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobilink_v2/Modal/car.dart';
import 'package:url_launcher/url_launcher.dart';

class CarDetailView extends StatelessWidget {
  final CarModel car;

  CarDetailView({required this.car});

  @override
  Widget build(BuildContext context) {
    // Tentukan koordinat latitude dan longitude secara manual
    final double latitude = -7.91785;
    final double longitude = 113.83455;

    return Scaffold(
      appBar: AppBar(
        title: Text('Car Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              car.foto_mobil,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              car.namaMobil,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCarInfoCard(Icons.people, 'Kapasitas', car.kapasitasPenumpang),
                  _buildCarInfoCard(Icons.local_gas_station, 'Bahan Bakar', car.bahanBakar),
                  _buildCarInfoCard(Icons.speed, 'Kecepatan', '${car.kecepatan} km/h'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(child: _buildMapCard(latitude, longitude)),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${car.hargaSewaPerhari} / day',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Aksi yang diambil saat tombol ditekan (misalnya, pemesanan)
              },
              child: Text('Order'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarInfoCard(IconData icon, String label, String value) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: 150,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(value),
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
}
