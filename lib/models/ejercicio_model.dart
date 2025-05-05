class Serie {
  String tipo; // calentamiento, normal, etc.
  int repeticiones;
  double peso;
  int rpe;

  Serie({
    required this.tipo,
    required this.repeticiones,
    required this.peso,
    required this.rpe,
  });

  factory Serie.fromJson(Map<String, dynamic> json) {
    return Serie(
      tipo: json['tipo'],
      repeticiones: json['repeticiones'],
      peso: (json['peso'] ?? 0).toDouble(),
      rpe: json['rpe'],
    );
  }

  Map<String, dynamic> toJson() => {
    'tipo': tipo,
    'repeticiones': repeticiones,
    'peso': peso,
    'rpe': rpe,
  };
}

class EjercicioEnRutina {
  String id;
  String ejercicioRef;
  int orden;
  List<Serie> series;

  EjercicioEnRutina({
    required this.id,
    required this.ejercicioRef,
    required this.orden,
    required this.series,
  });

  factory EjercicioEnRutina.fromJson(Map<String, dynamic> json, String id) {
    var seriesList = (json['series'] as List)
        .map((e) => Serie.fromJson(e))
        .toList();

    return EjercicioEnRutina(
      id: id,
      ejercicioRef: json['ejercicioRef'],
      orden: json['orden'],
      series: seriesList,
    );
  }

  Map<String, dynamic> toJson() => {
    'ejercicioRef': ejercicioRef,
    'orden': orden,
    'series': series.map((e) => e.toJson()).toList(),
  };
}
