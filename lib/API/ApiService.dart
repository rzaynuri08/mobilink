import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobilink_v2/Modal/PaymentModel.dart';
import 'package:mobilink_v2/Modal/Transaction.dart';
import 'package:mobilink_v2/Modal/TransactionModel.dart';
import 'package:mobilink_v2/Modal/booking.dart';
import 'package:mobilink_v2/Modal/car.dart';
import 'package:mobilink_v2/Modal/mitra.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<List<TransactionHistory>> fetchTransactions(String usernameMb, {int? status}) async {
    late String url;
    if (status != null) {
      url = "$apiUrl/transaksi/status/$status/$usernameMb/";
    } else {
      url = "$apiUrl/transaksi/$usernameMb/";
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<TransactionHistory> transactions = [];
      List<dynamic> data = json.decode(response.body);
      data.forEach((transaction) {
        transactions.add(TransactionHistory.fromJson(transaction));
      });
      return transactions;
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<List<Booking>> fetchBookings(String idMobil) async {
    final response = await http.get(Uri.parse('$apiUrl/booking/mobil/$idMobil'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  Future<List<Booking>> fetchOrder() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');
    
    if (username == null) {
      throw Exception("Username not found in SharedPreferences");
    }

    final response = await http.get(Uri.parse('$apiUrl/booking/username/$username/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in fetchOrder: $e');
    throw e;
  }
}
}
