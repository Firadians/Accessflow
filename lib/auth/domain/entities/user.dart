class User {
  final int id;
  final String name;
  final String ktp;
  final String photo;
  final String position;
  final String rememberToken;

  User({
    required this.id,
    required this.name,
    required this.ktp,
    required this.photo,
    required this.position,
    required this.rememberToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return User(
      id: data['id'] as int,
      name: data['name'] as String,
      ktp: data['ktp'] as String,
      photo: data['photo'] as String,
      position: data['position'] as String,
      rememberToken: data['remember_token'] as String,
    );
  }
  @override
  String toString() {
    return 'User(id: $id, name: $name, ktp: $ktp, photo: $photo, position: $position, rememberToken: $rememberToken)';
  }
}
