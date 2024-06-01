import 'package:flutter/material.dart';
import 'package:mobilink_v2/Modal/car.dart';
import 'package:mobilink_v2/API/ApiService.dart';
import 'package:mobilink_v2/Modal/mitra.dart';
import 'package:mobilink_v2/UI/CarDetailView.dart';
import 'package:mobilink_v2/utills/constants.dart';

class DealerDetailView extends StatefulWidget {
  final Dealer dealer;

  DealerDetailView({required this.dealer});

  @override
  _DealerDetailViewState createState() => _DealerDetailViewState();
}

class _DealerDetailViewState extends State<DealerDetailView> {
  late Future<List<CarModel>> _dealerCarsFuture;

  @override
  void initState() {
    super.initState();
    _dealerCarsFuture = ApiService().fetchDealerCars(widget.dealer.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        shadowColor: Colors.black,
        title: Text("Dealer Detail"),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: FutureBuilder<List<CarModel>>(
          future: _dealerCarsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              List<CarModel> cars = snapshot.data!;
              return ListView.builder(
                itemCount: cars.length,
                itemBuilder: (context, index) {
                  CarModel car = cars[index];
                  return _buildCarCard(context, car);
                },
              );
            } else {
              return Center(child: Text('No cars available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, CarModel car) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CarDetailView(car: car)),
        );
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                                Text(
                                  car.namaMobil,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  car.tipe,
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 14),
                                Text(
                                  'Rp. ${car.hargaSewaPerhari}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Image.network(
                  "https://mobilink.my.id/${car.foto_mobil}",
                  width: null,
                  height: null,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
