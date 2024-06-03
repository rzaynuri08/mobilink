import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobilink_v2/Modal/PaymentModel.dart';
import 'package:mobilink_v2/Modal/TransactionModel.dart';
import 'package:mobilink_v2/Modal/car.dart';
import 'package:mobilink_v2/Modal/mitra.dart';

class ApiService {
  final String apiUrl = "https://mobilink.my.id/api/billy123";

  Future<List<CarModel>> fetchCars() async {
    final response = await http.get(Uri.parse("$apiUrl/mobil"));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<CarModel> cars = body.map((dynamic item) => CarModel.fromJson(item)).toList();
      return cars;
    } else {
      throw Exception('Failed to load cars');
    }
  }

  Future<List<Dealer>> fetchDealers() async {
    final response = await http.get(Uri.parse('$apiUrl/mitra'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Dealer> dealers = data.map((item) => Dealer.fromJson(item)).toList();
      return dealers;
    } else {
      throw Exception('Failed to load dealers');
    }
  }
  
  Future<List<CarModel>> fetchDealerCars(String username) async {
    final response = await http.get(Uri.parse('$apiUrl/mobil/$username'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<CarModel> cars = body.map((dynamic item) => CarModel.fromJson(item)).toList();
      return cars;
    } else {
      throw Exception('Failed to load dealer cars');
    }
  }

  Future<List<Payment>> fetchPaymentMethod() async {
    final response = await http.get(Uri.parse('$apiUrl/jenis-pembayaran'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Payment> payments = jsonData.map((json) => Payment.fromJson(json)).toList();
      return payments;
    } else {
      throw Exception('Failed to load payments');
    }
  }

  static Future<void> sendTransaction(TransactionModel transaction) async {
    final response = await http.post(Uri.parse('https://mobilink.my.id/api/billy123/transaksi'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(transaction.toJson()));

    if (response.statusCode == 200) {
      print('Transaction sent successfully');
    } else {
      throw Exception('Failed to send transaction');
    }
  }
}
