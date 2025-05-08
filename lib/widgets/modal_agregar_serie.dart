import 'package:flutter/material.dart';

class ModalAgregarSerie extends StatelessWidget {
  const ModalAgregarSerie({Key? key}) : super(key: key);

  final List<Map<String, String>> tiposSerie = const [
    {'tipo': 'W', 'desc': 'Calentamiento'},
    {'tipo': '1', 'desc': 'Serie normal'},
    {'tipo': 'F', 'desc': 'Serie fallida'},
    {'tipo': 'D', 'desc': 'Drop set'},
    {'tipo': 'S', 'desc': 'Super serie'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: tiposSerie.map((tipo) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context, {
                'tipo': tipo['tipo'],
                'kg': '',
                'reps': '',
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tipo['tipo']!,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tipo['desc']!,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
