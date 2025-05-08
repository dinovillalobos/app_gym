import 'package:flutter/material.dart';

class ModalAgregarSerie extends StatefulWidget {
  final String? tipoInicial;
  final String? kgInicial;
  final String? repsInicial;

  const ModalAgregarSerie({
    super.key,
    this.tipoInicial,
    this.kgInicial,
    this.repsInicial,
  });

  @override
  State<ModalAgregarSerie> createState() => _ModalAgregarSerieState();
}

class _ModalAgregarSerieState extends State<ModalAgregarSerie> {
  String tipo = '1';
  final TextEditingController kgController = TextEditingController();
  final TextEditingController repsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tipo = widget.tipoInicial ?? '1';
    kgController.text = widget.kgInicial ?? '';
    repsController.text = widget.repsInicial ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Selecciona el tipo de serie'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['W', '1', 'F', 'D'].map((valor) {
              return ChoiceChip(
                label: Text(valor),
                selected: tipo == valor,
                onSelected: (_) {
                  setState(() => tipo = valor);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: kgController,
            decoration: const InputDecoration(labelText: 'Kg'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: repsController,
            decoration: const InputDecoration(labelText: 'Reps'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              if (kgController.text.isNotEmpty && repsController.text.isNotEmpty) {
                Navigator.pop(context, {
                  'tipo': tipo,
                  'kg': double.tryParse(kgController.text) ?? 0,
                  'reps': int.tryParse(repsController.text) ?? 0,
                });
              }
            },
            child: const Text('Agregar'),
          )
        ],
      ),
    );
  }
}
