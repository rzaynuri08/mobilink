import 'package:flutter/material.dart';
import '../API/ApiService.dart';
import '../Modal/car.dart';

class AvailableCars extends StatefulWidget {
  @override
  _AvailableCarsState createState() => _AvailableCarsState();
}

class _AvailableCarsState extends State<AvailableCars> {
  late Future<List<CarModel>> futureCars;

  @override
  void initState() {
    super.initState();
    futureCars = ApiService().fetchCars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Cars'),
      ),
      body: FutureBuilder<List<CarModel>>(
        future: futureCars,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cars available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                CarModel car = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(car.namaMobil),
                    subtitle: Text('Price per day: ${car.hargaSewaPerhari}'),
                    onTap: () {
                      // Navigate to the details or booking page if needed
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
