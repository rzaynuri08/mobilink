class CarModel {
  final String idMobil;
  final String namaMobil;
  final String kapasitasPenumpang;
  final String warna;
  final String hargaSewaPerhari;
  final String tipe;
  final String bahanBakar;
  final String kecepatan;
  final String foto_mobil;
  final String username;
  final double latitude; 
  final double longitude;
  final String transmisi;

  CarModel({
    required this.idMobil,
    required this.namaMobil,
    required this.kapasitasPenumpang,
    required this.warna,
    required this.hargaSewaPerhari,
    required this.tipe,
    required this.bahanBakar,
    required this.kecepatan,
    required this.foto_mobil,
    required this.username,
    required this.latitude,
    required this.longitude,
    required this.transmisi
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      idMobil: json['id_mobil'].toString(),
      namaMobil: json['nama_mobil'].toString(),
      kapasitasPenumpang: json['kapasitas_penumpang'].toString(),
      warna: json['warna'].toString(),
      hargaSewaPerhari: json['harga_sewa_perhari'].toString(),
      tipe: json['tipe'].toString(),
      bahanBakar: json['bahan_bakar'].toString(),
      kecepatan: json['kecepatan'].toString(),
      foto_mobil: json['foto_mobil'].toString(),
      username: json['username'].toString(),
      latitude: double.parse(json['latitude'].toString()), // Ubah menjadi double
      longitude: double.parse(json['longitude'].toString()), // Ubah menjadi double
      transmisi: json['transmisi'].toString(),
    );
  }
}
