import 'package:cloud_firestore/cloud_firestore.dart';

class RutinaModel {
  String id;
  String nombre;
  String descripcion;
  String nivel;
  String tipo;
  DateTime fechaCreacion;

  RutinaModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.nivel,
    required this.tipo,
    required this.fechaCreacion,
  });

  factory RutinaModel.fromJson(Map<String, dynamic> json, String id) {
    return RutinaModel(
      id: id,
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      nivel: json['nivel'] ?? '',
      tipo: json['tipo'] ?? '',
      fechaCreacion: (json['fecha_creacion'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'nivel': nivel,
      'tipo': tipo,
      'fecha_creacion': fechaCreacion,
    };
  }
}
