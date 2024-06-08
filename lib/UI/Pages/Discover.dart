import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilink_v2/API/ApiService.dart';
import 'package:mobilink_v2/UI/available_cars.dart';
import 'package:mobilink_v2/Modal/car.dart';
import 'package:mobilink_v2/Modal/user.dart';
import 'package:mobilink_v2/UI/CarDetailView.dart';
import 'package:mobilink_v2/UI/DealerDetailView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utills/constants.dart';
import 'package:mobilink_v2/API/ApiService.dart';
import 'package:mobilink_v2/Modal/mitra.dart';
import 'package:mobilink_v2/Modal/user.dart';
import 'package:http/http.dart' as http;

class CarListView extends StatelessWidget {
  final List<CarModel> cars;

  CarListView({required this.cars});

  @override
  Widget build(BuildContext context) {
    return UserDataFetcher(
      builder: (user) {
        return Scaffold(
          backgroundColor: kPrimaryColor,
          body: Column(
            children: [
              Container(
                color: kPrimaryColor,
                padding: EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mobilink',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(
                        user != null
                            ? "https://mobilink.my.id/${user.foto_profil}"
                            : 'https://via.placeholder.com/150',
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Nikmati liburan anda",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[100],
                                  ),
                                ),
                                Text(
                                  "dengan layanan kami",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[100],
                                  ),
                                ),
                                SizedBox(height: 24),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: TextField(
                                    controller: SearchController(),
                                    decoration: InputDecoration(
                                      hintText: 'Search a car...',
                                      hintStyle: TextStyle(fontSize: 16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                      suffixIcon: Padding(
                                        padding: EdgeInsets.only(right: 16.0),
                                        child: Icon(
                                          Icons.search,
                                          color: Colors.black,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "TOP DEALS",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "view all",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 12,
                                        color: kPrimaryColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 220,
                              child: ListView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: _buildCarCards(context),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AvailableCars()),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 16, right: 16, left: 16),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Available Cars",
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "Long term and short term",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                        ),
                                        height: 50,
                                        width: 50,
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "TOP DEALERS",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "view all",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 12,
                                        color: kPrimaryColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            DealerListView(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
        margin: EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  Text(
                    '${car.tipe}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                "https://mobilink.my.id/${car.foto_mobil}",
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Text(
                    'Rp. ${car.hargaSewaPerhari}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' /days',
                    style: TextStyle(
                      fontSize: 12,
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

  void _onCarCardTapped(BuildContext context, CarModel car) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarDetailView(car: car),
      ),
    );
  }
}
class DealerListView extends StatefulWidget {
  @override
  _DealerListViewState createState() => _DealerListViewState();
}

class _DealerListViewState extends State<DealerListView> {
  late Future<List<Dealer>> _dealerFuture;

  @override
  void initState() {
    super.initState();
    _dealerFuture = ApiService().fetchDealers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Dealer>>(
      future: _dealerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Container(
            height: 150,
            margin: EdgeInsets.only(bottom: 16),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Dealer dealer = snapshot.data![index];
                return _buildDealerCard(dealer);
              },
            ),
          );
        } else {
          return Text('No Data Available');
        }
      },
    );
  }

  Widget _buildDealerCard(Dealer dealer) {
  return GestureDetector(
    onTap: () {
      _onDealerCardTapped(context, dealer);
    },
    child: Container(
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          ClipOval(
            child: dealer.logoMitra.isNotEmpty
              ? Image.network(
                  "https://mobilink.my.id/${dealer.logoMitra}",
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                )
              : Icon(Icons.store, size: 80),
          ),
          SizedBox(height: 8),
          Text(
            dealer.namaToko.length <= 10
              ? dealer.namaToko
              : dealer.namaToko.substring(0, 10),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            dealer.namaLengkap,
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
  void _onDealerCardTapped(BuildContext context, Dealer dealer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DealerDetailView(dealer: dealer),
      ),
    );
  }
}

class UserDataFetcher extends StatefulWidget {
  final Widget Function(User?) builder;

  const UserDataFetcher({Key? key, required this.builder}) : super(key: key);

  @override
  _UserDataFetcherState createState() => _UserDataFetcherState();
}

class _UserDataFetcherState extends State<UserDataFetcher> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    if (username != null) {
      Uri url = Uri.parse('https://mobilink.my.id/api/billy123/users/$username');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          _user = User.fromJson(userData);
        });
      } else {
        // Handle server error
      }
    } else {
      // Handle user not found in shared preferences
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_user);
  }
}
