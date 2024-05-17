import 'package:flutter/material.dart';
import 'package:mobilink_v2/Modal/car.dart';
import 'package:mobilink_v2/UI/CarDetailView.dart';

class CarListView extends StatelessWidget {
  final List<CarModel> cars;

  CarListView({required this.cars});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Discover'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Deals',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle "View All" button press
                    },
                    child: Text('View All >'),
                  ),
                ],
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cars.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildCarCard(context, cars[index]);
                  },
                ),
              ),
              SizedBox(height: 16),
              _buildAvailableCarsButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, CarModel car) {
    return GestureDetector(
      onTap: () {
      _onCarCardTapped(context, car);
    },
      child: Container(
        width: 250,
        height: 300,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                car.foto_mobil,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.namaMobil,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
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
      ),
    );
  }

  Widget _buildAvailableCarsButton() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF7033FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available Cars',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Long term and short term',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_forward),
              color: Color(0xFF7033FF),
              onPressed: () {
                // Handle button press
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onCarCardTapped(BuildContext context, CarModel car) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CarDetailView(car: car),
    ),
  );
}
}
