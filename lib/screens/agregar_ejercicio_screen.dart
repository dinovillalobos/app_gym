import 'package:flutter/material.dart';
import '../data/ejercicios_mock.dart';

class AgregarEjerciciosScreen extends StatefulWidget {
  final String rutinaId;

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Selecciona Ejercicios',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: ejerciciosMock.length,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemBuilder: (context, index) {
          final ejercicio = ejerciciosMock[index];
          final seleccionado = estaSeleccionado(ejercicio);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  ejercicio['nombre'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Principal: ${ejercicio['musculo']} • Tipo: ${ejercicio['tipo']}',
                    style: const TextStyle(color: Colors.grey,fontSize: 13),
                  ),
                  Text(
                    'Secundarios: ${List<String>.from(ejercicio['musculosSecundarios']).join(', ')}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              subtitle: Text(
                '${ejercicio['musculo']}',
                style: const TextStyle(color: Colors.grey),
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
                checkColor: Colors.black,
                activeColor: Colors.green,
                side: const BorderSide(color: Colors.green),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        onPressed: _guardarSeleccion,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text(
          'Guardar',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}



