class TransactionHistory {
  final String idTransaksi;
  final String total;
  final String status;
  final String username;
  final String nama_toko;
  final String idMobil;
  final String foto_mobil;
  final String nama_mobil;
  final String tipe;
  final String harga;
  final String idJenis;
  final String namaPembayaran;
  final String tanggalMulai;
  final String tanggalAkhir;
  final String tipeBayar;
  final String tglTransaksi;

  TransactionHistory({
    required this.idTransaksi,
    required this.total,
    required this.status,
    required this.username,
    required this.nama_toko,
    required this.idMobil,
    required this.foto_mobil,
    required this.nama_mobil,
    required this.harga,
    required this.tipe,
    required this.idJenis,
    required this.namaPembayaran,
    required this.tanggalMulai,
    required this.tanggalAkhir,
    required this.tipeBayar,
    required this.tglTransaksi,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    return TransactionHistory(
      idTransaksi: json['id_transaksi'].toString(),
      total: json['total'].toString(),
      status: json['status'].toString(),
      username: json['username'].toString(),
      nama_toko: json['nama_toko'].toString(),
      idMobil: json['id_mobil'].toString(),
      foto_mobil: json['foto_mobil'].toString(),
      nama_mobil: json['nama_mobil'].toString(),
      tipe: json['tipe'].toString(),
      harga: json['harga_sewa_perhari'].toString(),
      idJenis: json['id_jenis'].toString(),
      namaPembayaran: json['nama_pembayaran'].toString(),
      tanggalMulai: json['tanggal_mulai'].toString(),
      tanggalAkhir: json['tanggal_akhir'].toString(),
      tipeBayar: json['tipe_bayar'].toString(),
      tglTransaksi: json['tgl_transaksi'].toString(),
    );
  }
}
