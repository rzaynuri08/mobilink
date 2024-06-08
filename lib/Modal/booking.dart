class Booking {
  final String idBooking;
  final String idMobil;
  final String foto_mobil;
  final String namaMobil;
  final String tipe;
  final DateTime tanggal_mulai;
  final DateTime tanggal_akhir;
  final String nama_toko;
  final String logo_mitra;
  final String status;

  Booking({
    required this.idBooking,
    required this.idMobil,
    required this.foto_mobil,
    required this.namaMobil,
    required this.tipe,
    required this.tanggal_mulai,
    required this.tanggal_akhir,
    required this.nama_toko,
    required this.logo_mitra,
    required this.status
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      idBooking: json['id_booking'].toString(),
      idMobil: json['id_mobil'].toString(),
      foto_mobil: json['foto_mobil'].toString(),
      namaMobil: json['nama_mobil'].toString(),
      tipe: json['tipe'].toString(),
      tanggal_mulai: DateTime.parse(json['tanggal_mulai'].toString()),
      tanggal_akhir: DateTime.parse(json['tanggal_akhir'].toString()),
      nama_toko: json['nama_toko'].toString(),
      logo_mitra: json['logo_mitra'].toString(),
      status: json['status'].toString()
    );
  }
}
