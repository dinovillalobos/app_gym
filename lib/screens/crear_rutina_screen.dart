import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/rutina_model.dart';
import '../services/rutina_service.dart';
import 'agregar_ejercicio_screen.dart';
import 'rutina_detail_screen.dart';

class CrearRutinaScreen extends StatefulWidget {
  const CrearRutinaScreen({Key? key, required String title, required String userId}) : super(key: key);

  @override
  State<CrearRutinaScreen> createState() => _CrearRutinaScreenState();
}

class _CrearRutinaScreenState extends State<CrearRutinaScreen> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  List<Map<String, dynamic>> ejercicios = [];

  void _agregarEjercicios() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AgregarEjerciciosScreen(rutinaId: ''),
      ),
    );

    if (resultado != null && resultado is List<Map<String, dynamic>>) {
      setState(() {
        for (var e in resultado) {
          if (!ejercicios.any((ex) => ex['nombre'] == e['nombre'])) {
            ejercicios.add({...e, 'series': []});
          }
        }
      });
    }
  }

  void _guardarRutina() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario no autenticado')),
      );
      return;
    }

    final nombre = nombreController.text.trim();
    final descripcion = descripcionController.text.trim();

    if (nombre.isEmpty || descripcion.isEmpty || ejercicios.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    final rutina = RutinaModel(
      id: '',
      idUsuario: user.uid,
      nombre: nombre,
      descripcion: descripcion,
      ejercicios: ejercicios,
    );

    final rutinaService = RutinaService(userId: user.uid);

    try {
      final nuevaRutina = await rutinaService.crearRutina(rutina);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DetalleRutinaScreen(rutina: nuevaRutina),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar rutina: $e')),
      );
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Lista de rutinas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.blue,
            height: 3.0,
            margin: const EdgeInsets.only(left: 16, right: 16),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _guardarRutina,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nombreController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nombre de la rutina',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descripcionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Descripción',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Agregar ejercicios'),
              onPressed: _agregarEjercicios,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E1E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (ejercicios.isNotEmpty) ...[
              const Text(
                'Ejercicios seleccionados:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              ...ejercicios.map((e) => ListTile(
                title: Text(e['nombre'], style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                  'Músculo: ${e['musculo']} • Tipo: ${e['tipo']}',
                  style: const TextStyle(color: Colors.white54),
                ),
              )),
            ]
          ],
        ),
      ),
    );
  }
}

