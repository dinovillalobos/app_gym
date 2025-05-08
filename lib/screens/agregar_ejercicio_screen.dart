import 'package:flutter/material.dart';
import 'package:app_gym_hibrido/models/ejercicio_model.dart';
import 'package:app_gym_hibrido/services/ejercicio_service.dart';

class AgregarEjercicioScreen extends StatefulWidget {
  final String userId;
  final String rutinaId;

  const AgregarEjercicioScreen({
    super.key,
    required this.userId,
    required this.rutinaId,
  });

  @override
  State<AgregarEjercicioScreen> createState() => _AgregarEjercicioScreenState();
}

class _AgregarEjercicioScreenState extends State<AgregarEjercicioScreen> {
  final nombreController = TextEditingController();
  final musculoController = TextEditingController();
  final seriesController = TextEditingController();
  final repeticionesController = TextEditingController();
  final tipoController = TextEditingController();
  final notasController = TextEditingController();

  late EjercicioService ejercicioService;

  @override
  void initState() {
    super.initState();
    ejercicioService = EjercicioService(
      userId: widget.userId,
      rutinaId: widget.rutinaId,
    );
  }

  Future<void> guardarEjercicio() async {
    final ejercicio = EjercicioModel(
      id: '', // Firestore asignará el ID
      nombre: nombreController.text.trim(),
      musculo: musculoController.text.trim(),
      series: int.tryParse(seriesController.text) ?? 0,
      repeticiones: int.tryParse(repeticionesController.text) ?? 0,
      tipo: tipoController.text.trim(),
      notas: notasController.text.trim(),
    );

    await ejercicioService.agregarEjercicio(ejercicio);
    Navigator.pop(context); // Volver a la pantalla anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Ejercicio')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre del ejercicio'),
            ),
            TextField(
              controller: musculoController,
              decoration: const InputDecoration(labelText: 'Músculo trabajado'),
            ),
            TextField(
              controller: tipoController,
              decoration: const InputDecoration(labelText: 'Tipo de ejercicio'),
            ),
            TextField(
              controller: seriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Series'),
            ),
            TextField(
              controller: repeticionesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Repeticiones'),
            ),
            TextField(
              controller: notasController,
              decoration: const InputDecoration(labelText: 'Notas (opcional)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: guardarEjercicio,
              child: const Text('Guardar Ejercicio'),
            ),
          ],
        ),
      ),
    );
  }
}
