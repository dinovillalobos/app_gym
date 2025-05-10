import 'package:flutter/material.dart';
import '../models/rutina_model.dart';
import '../services/rutina_service.dart';
import '../widgets/modal_agregar_serie.dart';
import 'agregar_ejercicio_screen.dart';

class DetalleRutinaScreen extends StatefulWidget {
  final RutinaModel rutina;

  const DetalleRutinaScreen({Key? key, required this.rutina}) : super(key: key);

  @override
  State<DetalleRutinaScreen> createState() => _DetalleRutinaScreenState();
}

class _DetalleRutinaScreenState extends State<DetalleRutinaScreen> {
  late List<Map<String, dynamic>> ejercicios;
  late RutinaService rutinaService;

  @override
  void initState() {
    super.initState();
    ejercicios = List<Map<String, dynamic>>.from(widget.rutina.ejercicios);
    rutinaService = RutinaService(userId: widget.rutina.idUsuario);
  }

  Future<void> _guardarCambios() async {
    final rutinaActualizada = widget.rutina.copyWith(ejercicios: ejercicios);

    try {
      await rutinaService.actualizarRutina(rutinaActualizada);
      if (mounted) Navigator.pop(context); // cerrar solo si la pantalla sigue activa
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar rutina: $e')),
        );
      }
    }
  }

  void _agregarEjercicios() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AgregarEjerciciosScreen(rutinaId: widget.rutina.id),
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

  void _agregarSerie(int indexEjercicio) async {
    final nuevaSerie = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ModalAgregarSerie(),
    );

    if (nuevaSerie != null) {
      setState(() {
        ejercicios[indexEjercicio]['series'] ??= [];
        ejercicios[indexEjercicio]['series'].add(nuevaSerie);
      });
    }
  }

  void _editarSerie(int indexEjercicio, int indexSerie) async {
    final serie = ejercicios[indexEjercicio]['series'][indexSerie];

    final resultado = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ModalAgregarSerie(
        tipoInicial: serie['tipo'] ?? '',
        kgInicial: serie['kg']?.toString() ?? '',
        repsInicial: serie['reps']?.toString() ?? '',
      ),
    );

    if (resultado != null) {
      setState(() {
        ejercicios[indexEjercicio]['series'][indexSerie] = resultado;
      });
    }
  }

  void _eliminarSerie(int indexEjercicio, int indexSerie) {
    setState(() {
      ejercicios[indexEjercicio]['series'].removeAt(indexSerie);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rutina.nombre),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Guardar',
            onPressed: _guardarCambios,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Agregar ejercicios',
            onPressed: _agregarEjercicios,
          ),
        ],
      ),
      body: ejercicios.isEmpty
          ? const Center(child: Text('No hay ejercicios aún.'))
          : ListView.builder(
        itemCount: ejercicios.length,
        itemBuilder: (context, indexEjercicio) {
          final ejercicio = ejercicios[indexEjercicio];
          final series = List<Map<String, dynamic>>.from(ejercicio['series'] ?? []);

          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ejercicio['nombre'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    'Principal: ${ejercicio['musculo']} • Tipo: ${ejercicio['tipo']}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ...series.asMap().entries.map((entry) {
                    final serie = entry.value;
                    final indexSerie = entry.key;

                    return ListTile(
                      title: Text('${serie['kg']} kg x ${serie['reps']} reps'),
                      subtitle: Text('Tipo: ${serie['tipo']}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (opcion) {
                          if (opcion == 'editar') {
                            _editarSerie(indexEjercicio, indexSerie);
                          } else if (opcion == 'eliminar') {
                            _eliminarSerie(indexEjercicio, indexSerie);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'editar', child: Text('Editar serie')),
                          PopupMenuItem(value: 'eliminar', child: Text('Eliminar serie')),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _agregarSerie(indexEjercicio),
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar serie'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

