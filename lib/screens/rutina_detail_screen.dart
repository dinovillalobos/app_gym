import 'package:flutter/material.dart';
import '../models/rutina_model.dart';
import 'agregar_ejercicio_screen.dart.';

class DetalleRutinaScreen extends StatefulWidget {
  final RutinaModel rutina;
  final String userId;

  const DetalleRutinaScreen({
    Key? key,
    required this.rutina,
    required this.userId,
  }) : super(key: key);

  @override
  State<DetalleRutinaScreen> createState() => _DetalleRutinaScreenState();
}

class _DetalleRutinaScreenState extends State<DetalleRutinaScreen> {
  List<Map<String, dynamic>> ejerciciosAgregados = [];

  void _agregarEjercicios() async {
    final seleccionados = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AgregarEjerciciosScreen(rutinaId: '',),
      ),
    );

    if (seleccionados != null && seleccionados is List<Map<String, dynamic>>) {
      setState(() {
        ejerciciosAgregados = seleccionados;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.rutina.nombre)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descripción: ${widget.rutina.descripcion}', style: TextStyle(fontSize: 16)),
            Text('Nivel: ${widget.rutina.nivel}', style: TextStyle(fontSize: 16)),
            Text('Tipo: ${widget.rutina.tipo}', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Ejercicios agregados:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (ejerciciosAgregados.isEmpty)
              const Text('No has agregado ejercicios aún.')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: ejerciciosAgregados.length,
                  itemBuilder: (context, index) {
                    final ejercicio = ejerciciosAgregados[index];
                    return Card(
                      child: ListTile(
                        title: Text(ejercicio['nombre']),
                        subtitle: Text(
                          'Principal: ${ejercicio['musculo']} • Tipo: ${ejercicio['tipo']}\n'
                              'Secundarios: ${List<String>.from(ejercicio['musculosSecundarios']).join(', ')}',
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregarEjercicios,
        icon: const Icon(Icons.add),
        label: const Text('Agregar ejercicios'),
      ),
    );
  }
}
