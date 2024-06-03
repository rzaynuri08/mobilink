class Payment {
  final String idJenis;
  final String namaPembayaran;
  final String noRek;
  final String logo;

  Payment({
    required this.idJenis,
    required this.namaPembayaran,
    required this.noRek,
    required this.logo,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      idJenis: json['id_jenis'].toString(),
      namaPembayaran: json['nama_pembayaran'].toString(),
      noRek: json['no_rek'].toString(),
      logo: json['logo'].toString(),
    );
  }
}
