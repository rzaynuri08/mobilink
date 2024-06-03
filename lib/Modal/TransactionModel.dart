class TransactionModel {
  final String total;
  final String username;
  final String username_mb;
  final String idMobil;
  final String idJenis;
  final String tanggal_mulai;
  final String tanggal_akhir;
  final String tipe_bayar;

  TransactionModel({
    required this.total,
    required this.username,
    required this.username_mb,
    required this.idMobil,
    required this.idJenis,
    required this.tanggal_mulai,
    required this.tanggal_akhir,
    required this.tipe_bayar,
  });

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'username': username,
      'username_mb': username_mb,
      'id_mobil': idMobil,
      'id_jenis': idJenis,
      'tanggal_mulai': tanggal_mulai,
      'tanggal_akhir': tanggal_akhir,
      'tipe_bayar': tipe_bayar,
    };
  }
}