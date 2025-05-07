class UsuarioModel {
  final String id;
  final String nombre;
  final String email;
  final String nivel;

  UsuarioModel({
    required this.id,
    required this.nombre,
    required this.email,
    required this.nivel,
  });

  // Convertir a JSON para guardar en Firestore
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'email': email,
      'nivel': nivel,
    };
  }

  // Crear un UsuarioModel desde JSON de Firestore
  factory UsuarioModel.fromJson(Map<String, dynamic> json, String id) {
    return UsuarioModel(
      id: id,
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      nivel: json['nivel'] ?? 'principiante',
    );
  }
}
