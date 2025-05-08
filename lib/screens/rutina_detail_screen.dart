import 'package:flutter/material.dart';
import 'agregar_ejercicio_screen.dart';
class DetalleRutinaScreen extends StatefulWidget {
  final String rutinaId;
  final String nombreRutina;

  const DetalleRutinaScreen({
    Key? key,
    required this.rutinaId,
    required this.nombreRutina,
  }) : super(key: key);

  @override
  State<DetalleRutinaScreen> createState() => _DetalleRutinaScreenState();
}

class _DetalleRutinaScreenState extends State<DetalleRutinaScreen> {
  List<String> ejercicios = [];

  void _agregarEjercicios() async {
    final ejerciciosSeleccionados = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AgregarEjerciciosScreen(),
      ),
    );

    if (ejerciciosSeleccionados != null) {
      setState(() {
        ejercicios.addAll(ejerciciosSeleccionados);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.nombreRutina)),
      body: ejercicios.isEmpty
          ? const Center(child: Text('No hay ejercicios agregados'))
          : ListView.builder(
        itemCount: ejercicios.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(ejercicios[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarEjercicios,
        child: const Icon(Icons.add),
      ),
    );
  }
}
