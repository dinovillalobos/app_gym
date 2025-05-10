class RutinaModel {
  final String id;
  final String idUsuario;
  final String nombre;
  final String descripcion;
  final List<Map<String, dynamic>> ejercicios;

  RutinaModel({
    this.id = '',
    required this.idUsuario,
    required this.nombre,
    required this.descripcion,
    required this.ejercicios,
  });

  /// Serializa la rutina para guardarla en Firestore
  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'nombre': nombre,
      'descripcion': descripcion,
      'ejercicios': ejercicios.map((ej) {
        return {
          'nombre': ej['nombre'] ?? '',
          'musculo': ej['musculo'] ?? '',
          'tipo': ej['tipo'] ?? '',
          'series': (ej['series'] as List?)?.map((s) => {
            'tipo': s['tipo'] ?? '',
            'kg': s['kg'] ?? '',
            'reps': s['reps'] ?? '',
          }).toList() ?? [],
        };
      }).toList(),
    };
  }

  /// Crea una rutina a partir de los datos de Firestore
  factory RutinaModel.fromJson(Map<String, dynamic> json, String id) {
    return RutinaModel(
      id: id,
      idUsuario: json['idUsuario'] ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      ejercicios: (json['ejercicios'] as List<dynamic>?)?.map((e) {
        return {
          'nombre': e['nombre'] ?? '',
          'musculo': e['musculo'] ?? '',
          'tipo': e['tipo'] ?? '',
          'series': (e['series'] as List<dynamic>?)?.map((s) {
            return {
              'tipo': s['tipo'] ?? '',
              'kg': s['kg'] ?? '',
              'reps': s['reps'] ?? '',
            };
          }).toList() ?? [],
        };
      }).toList() ?? [],
    );
  }

  /// Crea una copia de la rutina con cambios opcionales
  RutinaModel copyWith({
    String? id,
    String? idUsuario,
    String? nombre,
    String? descripcion,
    List<Map<String, dynamic>>? ejercicios,
  }) {
    return RutinaModel(
      id: id ?? this.id,
      idUsuario: idUsuario ?? this.idUsuario,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      ejercicios: ejercicios ?? this.ejercicios,
    );
  }
}
