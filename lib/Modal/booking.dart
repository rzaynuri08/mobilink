import 'dart:ffi';

class Booking {
  String idBooking;
  String idMobil;
  String usernameMb;
  String namaMobil;
  String tipe;
  String fotoMobil;
  final DateTime tanggal_mulai;
  final DateTime tanggal_akhir;
  String status;
  final double latitude;
  final double longitude;
  String namaToko;
  String logoMitra;

  Booking({
    required this.idBooking,
    required this.idMobil,
    required this.usernameMb,
    required this.namaMobil,
    required this.tipe,
    required this.fotoMobil,
    required this.tanggal_mulai,
    required this.tanggal_akhir,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.namaToko,
    required this.logoMitra,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      idBooking: json['id_booking'].toString(),
      idMobil: json['id_mobil'].toString(),
      usernameMb: json['username_mb'].toString(),
      namaMobil: json['nama_mobil'].toString(),
      tipe: json['tipe'].toString(),
      fotoMobil: json['foto_mobil'].toString(),
      tanggal_mulai: DateTime.parse(json['tanggal_mulai'].toString()),
      tanggal_akhir: DateTime.parse(json['tanggal_akhir'].toString()),
      status: json['status'].toString(),
      latitude: double.parse(json['latitude'].toString()), // Ubah menjadi double
      longitude: double.parse(json['longitude'].toString()),
      namaToko: json['nama_toko'].toString(),
      logoMitra: json['logo_mitra'].toString(),
    );
  }
}