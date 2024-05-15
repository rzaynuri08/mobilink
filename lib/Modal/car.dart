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
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
  return CarModel(
    idMobil: json['id_mobil'].toString(), // Ubah menjadi string jika seharusnya bertipe String
    namaMobil: json['nama_mobil'],
    kapasitasPenumpang: json['kapasitas_penumpang'].toString(), // Ubah menjadi string jika seharusnya bertipe String
    warna: json['warna'],
    hargaSewaPerhari: json['harga_sewa_perhari'].toString(), // Ubah menjadi string jika seharusnya bertipe String
    tipe: json['tipe'],
    bahanBakar: json['bahan_bakar'],
    kecepatan: json['kecepatan'].toString(), // Ubah menjadi string jika seharusnya bertipe String
    foto_mobil: json['foto_mobil'],
    username: json['username'],
  );
}
}
