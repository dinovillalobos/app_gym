import 'package:flutter/material.dart';
import 'package:app_gym_hibrido/models/rutina_model.dart';
import 'package:app_gym_hibrido/screens/agregar_ejercicio_screen.dart';

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


  @override
  State<DetalleRutinaScreen> createState() => _DetalleRutinaScreenState();
}

class _DetalleRutinaScreenState extends State<DetalleRutinaScreen> {
  List<Map<String, String>> ejercicios = [];

  @override
  void initState() {
    super.initState();
    // Aquí puedes cargar ejercicios desde Firestore si los guardas allí
    // Por ahora lo dejamos vacío y se llena con los que se agreguen
  }

  Future<void> _navegarYAgregarEjercicios() async {
    final ejerciciosSeleccionados = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AgregarEjerciciosScreen(rutinaId: widget.rutina.id),
      ),
    );

    if (ejerciciosSeleccionados != null && ejerciciosSeleccionados is List<Map<String, String>>) {
      setState(() {
        ejercicios.addAll(ejerciciosSeleccionados);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Rutina: ${widget.rutina.nombre}'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ejercicios.isEmpty
              ? const Center(child: Text('No hay ejercicios agregados.'))
              : ListView.builder(
            itemCount: ejercicios.length,
            itemBuilder: (context, index) {
              final ejercicio = ejercicios[index];
              return ListTile(
                title: Text(ejercicio['nombre'] ?? ''),
                subtitle: Text(
                    'Músculo principal: ${ejercicio['musculo'] ?? ''} | Tipo: ${ejercicio['tipo'] ?? ''}'),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: _navegarYAgregarEjercicios,
            child: const Icon(Icons.add),
            tooltip: 'Agregar Ejercicios',
            ),
        );
    }
}
