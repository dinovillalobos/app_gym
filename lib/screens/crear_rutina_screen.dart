import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/rutina_model.dart';
import 'agregar_ejercicio_screen.dart';

class CrearRutinaScreen extends StatefulWidget {
  final String userId;

  const CrearRutinaScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<CrearRutinaScreen> createState() => _CrearRutinaScreenState();
}

class _CrearRutinaScreenState extends State<CrearRutinaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  List<Map<String, dynamic>> ejerciciosSeleccionados = [];

  Future<void> _seleccionarEjercicios() async {
    final seleccionados = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AgregarEjerciciosScreen(rutinaId: ''),
      ),
    );

    if (seleccionados != null && seleccionados is List<Map<String, dynamic>>) {
      setState(() {
        ejerciciosSeleccionados = seleccionados;
      });
    }
  }

  Future<void> _guardarRutina() async {
    if (_formKey.currentState!.validate()) {
      try {
        final docRef = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(widget.userId)
            .collection('rutinas')
            .add({
          'nombre': _nombreController.text,
          'descripcion': _descripcionController.text,
          'fecha_creacion': Timestamp.now(),
        });

        // Guardar ejercicios dentro de la subcolección "ejercicios"
        for (var ejercicio in ejerciciosSeleccionados) {
          await docRef.collection('ejercicios').add(ejercicio);
        }

        Navigator.pop(context);
      } catch (e) {
        print('Error al guardar rutina: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar la rutina')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear nueva rutina')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre de la rutina'),
                validator: (value) =>
                value!.isEmpty ? 'Ingresa un nombre' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) =>
                value!.isEmpty ? 'Ingresa una descripción' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _seleccionarEjercicios,
                icon: const Icon(Icons.fitness_center),
                label: const Text('Agregar ejercicios'),
              ),
              const SizedBox(height: 16),
              if (ejerciciosSeleccionados.isNotEmpty) ...[
                const Text(
                  'Ejercicios seleccionados:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...ejerciciosSeleccionados.map((e) => ListTile(
                  title: Text(e['nombre']),
                  subtitle: Text('Músculo: ${e['musculo']} • Tipo: ${e['tipo']}'),
                )),
              ],
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _guardarRutina,
                icon: const Icon(Icons.save),
                label: const Text('Guardar rutina'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
