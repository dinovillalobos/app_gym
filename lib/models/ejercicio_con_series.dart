
class EjercicioConSeries {
  final String nombre;
  final String musculo;
  final String tipo;
  List<Map<String, dynamic>> series;

  EjercicioConSeries({
    required this.nombre,
    required this.musculo,
    required this.tipo,
    this.series = const [],
  });
}
