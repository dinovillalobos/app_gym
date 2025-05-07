class UsuarioModel {
  final String uid;
  final String email;
  final String username;

  UsuarioModel({
    required this.uid,
    required this.email,
    required this.username,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json, String uid) {
    return UsuarioModel(
      uid: uid,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
    };
  }
}
