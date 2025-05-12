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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(widget.rutina.nombre, style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_as, color: Colors.white),
            tooltip: 'Guardar',
            onPressed: _guardarCambios,
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            tooltip: 'Agregar ejercicios',
            onPressed: _agregarEjercicios,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.blueAccent,
            height: 3.0,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
      body: ejercicios.isEmpty
          ? const Center(
        child: Text('No hay ejercicios aún.', style: TextStyle(color: Colors.white)),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: ejercicios.length,
        itemBuilder: (context, indexEjercicio) {
          final ejercicio = ejercicios[indexEjercicio];
          final series = List<Map<String, dynamic>>.from(ejercicio['series'] ?? []);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ejercicio['nombre'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Principal: ${ejercicio['musculo']} • Tipo: ${ejercicio['tipo']}',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  if (series.isNotEmpty) const SizedBox(height: 10),
                  ...series.asMap().entries.map((entry) {
                    final serie = entry.value;
                    final indexSerie = entry.key;

                    Color color;
                    switch (serie['tipo']) {
                      case 'W':
                        color = Colors.amber;
                        break;
                      case 'F':
                        color = Colors.redAccent;
                        break;
                      case 'D':
                        color = Colors.blue;
                        break;
                      case '1':
                        color = Colors.greenAccent;
                        break;
                      default:
                        color = Colors.white;
                    }

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${serie['kg']} kg x ${serie['reps']} reps',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                serie['tipo'],
                                style: TextStyle(
                                  color: color.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              PopupMenuButton<String>(
                                color: const Color(0xFF2A2A2A),
                                icon: const Icon(Icons.more_vert, color: Colors.white70, size: 20),
                                onSelected: (opcion) {
                                  if (opcion == 'editar') {
                                    _editarSerie(indexEjercicio, indexSerie);
                                  } else if (opcion == 'eliminar') {
                                    _eliminarSerie(indexEjercicio, indexSerie);
                                  }
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(value: 'editar', child: Text('Editar serie',
                                  style: TextStyle(color: Colors.white),)),
                                  PopupMenuItem(value: 'eliminar', child: Text('Eliminar serie',
                                  style: TextStyle(color: Colors.white),)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blueAccent,
                      ),
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

