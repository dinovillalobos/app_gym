class RutinaModel {
  final String id;
  final String nombre;
  final String descripcion;
  final List<Map<String, dynamic>> ejercicios;

  RutinaModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.ejercicios,
  });

  factory RutinaModel.fromJson(Map<String, dynamic> json, String id) {
    return RutinaModel(
      id: id,
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      ejercicios: List<Map<String, dynamic>>.from(json['ejercicios'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'ejercicios': ejercicios,
    };
  }
}

