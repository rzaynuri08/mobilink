import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobilink_v2/Modal/car.dart';
import 'package:mobilink_v2/API/ApiService.dart';
import 'package:mobilink_v2/Modal/mitra.dart';
import 'package:mobilink_v2/UI/CarDetailView.dart';
import 'package:mobilink_v2/utills/constants.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 160, // Set a fixed height for the map
                  width: double.infinity,
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(widget.dealer.latitude, widget.dealer.longitude),
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
                            point: LatLng(widget.dealer.latitude, widget.dealer.longitude),
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
                Positioned(
                  left: MediaQuery.of(context).size.width / 2 - 40, // Adjust the position as needed
                  top: 120, // Adjust the position as needed
                  child: ClipOval(
                    child: Image.network(
                      'https://mobilink.my.id/${widget.dealer.logoMitra}', // Replace with your image path
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              child: Transform.translate(
                offset: Offset(0, -40),
                child: ClipOval(
                  child: Image.network(
                    'https://mobilink.my.id/${widget.dealer.logoMitra}', // Ganti dengan path gambar Anda
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -25),
              child: Container(
                child: Column(
                  children: [
                    Text(
                      widget.dealer.namaToko,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
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
          ],
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
