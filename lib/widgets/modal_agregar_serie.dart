import 'package:flutter/material.dart';

class ModalAgregarSerie extends StatefulWidget {
  final String tipoInicial;
  final String kgInicial;
  final String repsInicial;

  const ModalAgregarSerie({
    Key? key,
    this.tipoInicial = '',
    this.kgInicial = '',
    this.repsInicial = '',
  }) : super(key: key);

  @override
  State<ModalAgregarSerie> createState() => _ModalAgregarSerieState();
}

class _ModalAgregarSerieState extends State<ModalAgregarSerie> {
  String? tipo;
  final TextEditingController kgController = TextEditingController();
  final TextEditingController repsController = TextEditingController();

  final List<Map<String, String>> tiposDeSerie = [
    {'valor': 'W', 'descripcion': 'Calentamiento (Warm-up)'},
    {'valor': '1', 'descripcion': 'Serie 1'},
    {'valor': '2', 'descripcion': 'Serie 2'},
    {'valor': '3', 'descripcion': 'Serie 3'},
    {'valor': '4', 'descripcion': 'Serie 4'},
    {'valor': 'D', 'descripcion': 'Drop set'},
    {'valor': 'F', 'descripcion': 'Serie fallida'},
  ];

  @override
  void initState() {
    super.initState();
    tipo = widget.tipoInicial;
    kgController.text = widget.kgInicial;
    repsController.text = widget.repsInicial;
  }

  void _guardarSerie() {
    if (tipo != null && kgController.text.isNotEmpty && repsController.text.isNotEmpty) {
      Navigator.pop(context, {
        'tipo': tipo,
        'kg': double.tryParse(kgController.text) ?? 0,
        'reps': int.tryParse(repsController.text) ?? 0,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Selecciona tipo de serie',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ...tiposDeSerie.map((t) {
            return ListTile(
              title: Text('${t['valor']} - ${t['descripcion']}'),
              leading: Radio<String>(
                value: t['valor']!,
                groupValue: tipo,
                onChanged: (value) => setState(() => tipo = value),
              ),
            );
          }).toList(),
          TextField(
            controller: kgController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Peso (kg)'),
          ),
          TextField(
            controller: repsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Repeticiones'),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _guardarSerie,
            icon: const Icon(Icons.check),
            label: const Text('Guardar serie'),
          ),
        ],
      ),
    );
  }
}
