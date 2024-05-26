class User {
  final String username;
  final String password;
  final String name;
  final String email;
  final String phoneNumber;
  final String birthDate;
  final String domicile;
  final String foto_profil;

  User({
    required this.username,
    required this.password,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.domicile,
    required this.foto_profil,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username_mb'],
      password: json['password'],
      name: json['nama'],
      email: json['email'],
      phoneNumber: json['nomor_hp_user'],
      birthDate: json['tgl_lahir'],
      domicile: json['domisili'],
      foto_profil: json['foto_profil'],
    );
  }
}
