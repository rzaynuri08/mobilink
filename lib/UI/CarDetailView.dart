import 'package:flutter/material.dart';
import 'package:mobilink_v2/Modal/car.dart';

class CarDetailView extends StatelessWidget {
  final CarModel car; // Menggunakan objek CarModel sebagai parameter

  CarDetailView({required this.car}); // Menggunakan objek CarModel sebagai parameter

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 8),
            Text(
              '${car.hargaSewaPerhari}',
              style: TextStyle(
                fontSize: 16,
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
          ],
        ),
      ),
    );
  }

  Widget _buildCarInfoCard(IconData icon, String label, String value) {
  return Card(
    // Menetapkan lebar kartu agar sama untuk semua
    margin: EdgeInsets.symmetric(horizontal: 4), // Atur jarak antar kartu
    child: SizedBox( // Menggunakan SizedBox untuk menetapkan ukuran kartu
      width: 150, // Atur lebar kartu sesuai kebutuhan
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
}