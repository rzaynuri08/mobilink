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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Discover'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 0, 
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: EdgeInsets.only(left: 30,),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 24.0, left: 16.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 24,
                    ),
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
              Container(
                height: 220,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: _buildCarCards(context),
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

  List<Widget> _buildCarCards(BuildContext context) {
    return cars.map((car) => _buildCarCard(context, car)).toList();
  }

  Widget _buildCarCard(BuildContext context, CarModel car) {
    return GestureDetector(
      onTap: () {
        _onCarCardTapped(context, car);
      },
      child: Container(
        width: 180,
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: Card(
          color: Colors.white,
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
                height: 100,
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
