import 'package:flutter/material.dart';
import '../models/rutina_model.dart';
import '../widgets/modal_agregar_serie.dart';
import 'agregar_ejercicio_screen.dart';

class DetalleRutinaScreen extends StatefulWidget {
  final RutinaModel rutina;

  const DetalleRutinaScreen({Key? key, required this.rutina}) : super(key: key);

  @override
  State<DetalleRutinaScreen> createState() => _DetalleRutinaScreenState();
}

class _DetalleRutinaScreenState extends State<DetalleRutinaScreen> {
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

  void _agregarSerie(int indexEjercicio) {
    setState(() {
      ejercicios[indexEjercicio]['series'].add({
        'tipo': '',
        'kg': '',
        'reps': '',
      });
    });
  }

  void _editarCampo(int indexEjercicio, int indexSerie, String campo) async {
    if (campo == 'tipo') {
      final tipoElegido = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const ModalAgregarSerie(),
      );

      if (tipoElegido != null) {
        setState(() {
          ejercicios[indexEjercicio]['series'][indexSerie]['tipo'] = tipoElegido['tipo'];
        });
      }
    } else {
      final controlador = TextEditingController(
        text: ejercicios[indexEjercicio]['series'][indexSerie][campo],
      );

      final nuevoValor = await showDialog<String>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Editar $campo'),
          content: TextField(
            controller: controlador,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: campo),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(onPressed: () => Navigator.pop(context, controlador.text), child: const Text('Guardar')),
          ],
        ),
      );

      if (nuevoValor != null) {
        setState(() {
          ejercicios[indexEjercicio]['series'][indexSerie][campo] = nuevoValor;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rutina.nombre),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _agregarEjercicios,
            tooltip: 'Agregar ejercicios',
          ),
        ],
      ),
      body: ejercicios.isEmpty
          ? const Center(child: Text('No hay ejercicios aún.'))
          : ListView.builder(
        itemCount: ejercicios.length,
        itemBuilder: (context, indexEjercicio) {
          final ejercicio = ejercicios[indexEjercicio];
          final series = ejercicio['series'] as List;

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
                  const SizedBox(height: 12),
                  Table(
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: const {
                      0: FixedColumnWidth(60),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                    },
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(color: Colors.black12),
                        children: [
                          Padding(padding: EdgeInsets.all(8), child: Text('Serie', textAlign: TextAlign.center)),
                          Padding(padding: EdgeInsets.all(8), child: Text('KG', textAlign: TextAlign.center)),
                          Padding(padding: EdgeInsets.all(8), child: Text('Reps', textAlign: TextAlign.center)),
                        ],
                      ),
                      for (int i = 0; i < series.length; i++)
                        TableRow(
                          children: [
                            _celdaEditable(indexEjercicio, i, 'tipo'),
                            _celdaEditable(indexEjercicio, i, 'kg'),
                            _celdaEditable(indexEjercicio, i, 'reps'),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
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

  Widget _celdaEditable(int iEjercicio, int iSerie, String campo) {
    final valor = ejercicios[iEjercicio]['series'][iSerie][campo];
    return GestureDetector(
      onTap: () => _editarCampo(iEjercicio, iSerie, campo),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Text(valor.isEmpty ? '-' : valor.toString()),
        ),
      ),
    );
  }
}
