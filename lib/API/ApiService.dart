import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobilink_v2/Modal/car.dart';
import 'package:mobilink_v2/Modal/mitra.dart';

class ApiService {
  final String apiUrl = "https://mobilink.my.id/api/billy123/mobil";

  Future<List<CarModel>> fetchCars() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<CarModel> cars = body.map((dynamic item) => CarModel.fromJson(item)).toList();
      return cars;
    } else {
      throw Exception('Failed to load cars');
    }
  }

  Future<List<Dealer>> fetchDealers() async {
    final response = await http.get(Uri.parse('https://mobilink.my.id/api/billy123/mitra'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Dealer> dealers = data.map((item) => Dealer.fromJson(item)).toList();
      return dealers;
    } else {
      throw Exception('Failed to load dealers');
    }
  }
}
