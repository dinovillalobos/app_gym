import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_gym_hibrido/models/ejercicio_model.dart';

/*class EjercicioCompletado {
  String ejercicioRef;
  List<Serie> series;

  EjercicioCompletado({
    required this.ejercicioRef,
    required this.series,
  });

  factory EjercicioCompletado.fromJson(Map<String, dynamic> json) {
    var seriesList = (json['series'] as List)
        .map((e) => Serie.fromJson(e))
        .toList();

    return EjercicioCompletado(
      ejercicioRef: json['ejercicioRef'],
      series: seriesList,
    );
  }

  Map<String, dynamic> toJson() => {
    'ejercicioRef': ejercicioRef,
    'series': series.map((e) => e.toJson()).toList(),
  };
}

class ProgresoModel {
  String id;
  String rutinaRef;
  DateTime fecha;
  List<EjercicioCompletado> ejerciciosCompletados;

  ProgresoModel({
    required this.id,
    required this.rutinaRef,
    required this.fecha,
    required this.ejerciciosCompletados,
  });

  factory ProgresoModel.fromJson(Map<String, dynamic> json, String id) {
    var ejercicios = (json['ejerciciosCompletados'] as List)
        .map((e) => EjercicioCompletado.fromJson(e))
        .toList();

    return ProgresoModel(
      id: id,
      rutinaRef: json['rutinaRef'],
      fecha: (json['fecha'] as Timestamp).toDate(),
      ejerciciosCompletados: ejercicios,
    );
  }

  Map<String, dynamic> toJson() => {
    'rutinaRef': rutinaRef,
    'fecha': fecha,
    'ejerciciosCompletados':
    ejerciciosCompletados.map((e) => e.toJson()).toList(),
  };
}
*/