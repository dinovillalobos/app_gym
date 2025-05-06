import 'package:flutter/material.dart';
import '../models/rutina_model.dart';

class RutinaCard extends StatelessWidget {
  final RutinaModel rutina;

  const RutinaCard({required this.rutina});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(rutina.nombre),
        subtitle: Text('${rutina.descripcion} • Nivel: ${rutina.nivel}'),
        trailing: Icon(Icons.fitness_center),
        onTap: () {
          // Aquí luego puedes navegar a detalle
        },
      ),
    );
  }
}
