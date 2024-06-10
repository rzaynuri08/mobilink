class Dealer {
  final String username;
  final String namaLengkap;
  final String nomorHp;
  final String namaToko;
  final double latitude;
  final double longitude;
  final String statusAkun;
  final String logoMitra;
  final String idLevel;
  final String tanggalDaftar;

  Dealer({
    required this.username,
    required this.namaLengkap,
    required this.nomorHp,
    required this.namaToko,
    required this.latitude,
    required this.longitude,
    required this.statusAkun,
    required this.logoMitra,
    required this.idLevel,
    required this.tanggalDaftar,
  });

  factory Dealer.fromJson(Map<String, dynamic> json) {
    return Dealer(
      username: json['username'].toString(),
      namaLengkap: json['nama_lengkap'].toString(),
      nomorHp: json['nomor_hp'].toString(),
      namaToko: json['nama_toko'].toString(),
      latitude: double.parse(json['latitude'].toString()), // Ubah menjadi double
      longitude: double.parse(json['longitude'].toString()),
      statusAkun: json['status_akun'].toString(),
      logoMitra: json['logo_mitra'].toString(),
      idLevel: json['id_lvl'].toString(),
      tanggalDaftar: json['tgl_daftar'].toString(),
    );
  }
}
