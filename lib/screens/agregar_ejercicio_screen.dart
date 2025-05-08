import 'package:flutter/material.dart';
import '../data/ejercicios_mock.dart';

class AgregarEjerciciosScreen extends StatefulWidget {
  final String rutinaId; // ✅ Nuevo parámetro obligatorio

  const AgregarEjerciciosScreen({
    Key? key,
    required this.rutinaId,
  }) : super(key: key);

  @override
  State<AgregarEjerciciosScreen> createState() => _AgregarEjerciciosScreenState();
}

class _AgregarEjerciciosScreenState extends State<AgregarEjerciciosScreen> {
  final List<Map<String, dynamic>> seleccionados = [];

  void _guardarSeleccion() {
    Navigator.pop(context, seleccionados);
  }

  bool estaSeleccionado(Map<String, dynamic> ejercicio) {
    return seleccionados.any((e) => e['nombre'] == ejercicio['nombre']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona ejercicios'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text('Rutina ID: ${widget.rutinaId}', style: const TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: ejerciciosMock.length,
        itemBuilder: (context, index) {
          final ejercicio = ejerciciosMock[index];
          final seleccionado = estaSeleccionado(ejercicio);

          return ListTile(
            title: Text(ejercicio['nombre']),
            subtitle: Text(
              'Principal: ${ejercicio['musculo']} • Tipo: ${ejercicio['tipo']}'
                  '\nSecundarios: ${List<String>.from(ejercicio['musculosSecundarios']).join(', ')}',
            ),
            trailing: Checkbox(
              value: seleccionado,
              onChanged: (valor) {
                setState(() {
                  if (valor == true && !seleccionado) {
                    seleccionados.add(ejercicio);
                  } else {
                    seleccionados.removeWhere((e) => e['nombre'] == ejercicio['nombre']);
                  }
                });
              },
            ),
            isThreeLine: true,
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _guardarSeleccion,
        icon: const Icon(Icons.save),
        label: const Text('Guardar'),
      ),
    );
  }
}


