class EjercicioModel {
  String id;
  String nombre;
  String musculo;
  int series;
  int repeticiones;
  String tipo;
  String? notas;

  EjercicioModel({
    required this.id,
    required this.nombre,
    required this.musculo,
    required this.series,
    required this.repeticiones,
    required this.tipo,
    this.notas,
  });

  factory EjercicioModel.fromJson(Map<String, dynamic> json, String id) {
    return EjercicioModel(
      id: id,
      nombre: json['nombre'],
      musculo: json['musculo'],
      series: json['series'],
      repeticiones: json['repeticiones'],
      tipo: json['tipo'],
      notas: json['notas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'musculo': musculo,
      'series': series,
      'repeticiones': repeticiones,
      'tipo': tipo,
      'notas': notas,
    };
  }
}

