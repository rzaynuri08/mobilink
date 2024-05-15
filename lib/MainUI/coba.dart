import 'package:flutter/material.dart';
import 'package:mobilink_v2/Modal/car.dart'; // Pastikan untuk mengimpor model CarModel

class CarListView extends StatelessWidget {
  final List<CarModel> cars; // List data mobil
  CarListView({required this.cars}); // Konstruktor

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 285,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: cars.length,
        itemBuilder: (context, index) {
          return _buildCarCard(context, cars[index]); // Memanggil fungsi untuk membuat kartu mobil
        },
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, CarModel car) {
    return Container(
      width: 200, // Lebar kartu
      margin: EdgeInsets.symmetric(horizontal: 8), // Margin horizontal antara kartu
      child: Card(
        elevation: 4, // Elevasi kartu
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Bentuk sisi kartu
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar mobil (saya asumsikan ada URL gambar dalam model CarModel)
            Image.network(
              car.foto_mobil,
              width: 200, // Lebar gambar
              height: 150, // Tinggi gambar
              fit: BoxFit.cover, // Posisi gambar
            ),

            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama mobil
                  Text(
                    car.namaMobil,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  // Harga sewa perhari
                  Text(
                    '${car.hargaSewaPerhari}',
                    style: TextStyle(
                      fontSize: 14,
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
}
