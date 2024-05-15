import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobilink_v2/Modal/car.dart';

class ApiService {
  final String apiUrl = "https://mobilinkqz.my.id/api/billy123/mobil";

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
}
