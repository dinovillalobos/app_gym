import 'package:cloud_firestore/cloud_firestore.dart';

class RutinaModel {
  final String id;
  final String nombre;
  final String descripcion;
  final List<Map<String, dynamic>> ejercicios;

  RutinaModel({
    this.id = '',
    required this.nombre,
    required this.descripcion,
    required this.ejercicios,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'ejercicios': ejercicios.map((ej) {
        return {
          'nombre': ej['nombre'],
          'musculo': ej['musculo'],
          'tipo': ej['tipo'],
          'series': (ej['series'] as List).map((s) => {
            'tipo': s['tipo'],
            'kg': s['kg'],
            'reps': s['reps'],
          }).toList(),
        };
      }).toList(),
    };
  }

  factory RutinaModel.fromJson(Map<String, dynamic> json, String id) {
    return RutinaModel(
      id: id,
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
          }).toList() ??
              [],
        };
      }).toList() ??
          [],
    );
  }
}
