import 'package:app_gym_hibrido/screens/rutina_detail_screen.dart';
import 'package:flutter/material.dart';
import '../models/rutina_model.dart';
import '../screens/rutina_detail_screen.dart';

class RutinaCard extends StatelessWidget {
  final RutinaModel rutina;

  const RutinaCard({super.key, required this.rutina});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(rutina.nombre),
        subtitle: Text(rutina.descripcion),
        trailing: const Icon(Icons.fitness_center),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetalleRutinaScreen(rutina: rutina),
            ),
          );
        },
      ),
    );
  }
}
