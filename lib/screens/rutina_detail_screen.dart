import 'package:flutter/material.dart';
import 'package:app_gym_hibrido/screens/agregar_ejercicio_screen.dart';

class RutinaDetalleScreen extends StatelessWidget {
  final String userId;
  final String rutinaId;

  const RutinaDetalleScreen({
    super.key,
    required this.userId,
    required this.rutinaId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Rutina')),
      body: Center(
        child: Text('Aquí se mostrarán los ejercicios de la rutina'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AgregarEjercicioScreen(
                userId: userId,
                rutinaId: rutinaId,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
