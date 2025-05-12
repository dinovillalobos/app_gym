import 'package:flutter/material.dart';
import '../data/ejercicios_mock.dart';
import '../data/ejercicios_pliometrico.dart';

class AgregarEjerciciosScreen extends StatefulWidget {
  final String rutinaId;

  const AgregarEjerciciosScreen({
    Key? key,
    required this.rutinaId,
  }) : super(key: key);

  @override
  State<AgregarEjerciciosScreen> createState() => _AgregarEjerciciosScreenState();
}

class _AgregarEjerciciosScreenState extends State<AgregarEjerciciosScreen> {
  final List<Map<String, dynamic>> seleccionados = [];

  /*
  Aqui estamos haciendo una lista en donde vamos a guardar las listas que contiene los
  archivos con los ejercicios, solo hacemos una ya que esta la referenciaremos para que
  sea una sola, dentro de este mismo va a estar y solo es cuetión de importar los archivos.
   */
  final List<Map<String, dynamic>> ejerciciosTotales = [
    ...ejerciciosMock,
    ...ejerciciosPliometricos,
  ];

  void _guardarSeleccion() {
    Navigator.pop(context, seleccionados);
  }

  bool estaSeleccionado(Map<String, dynamic> ejercicio) {
    return seleccionados.any((e) => e['nombre'] == ejercicio['nombre']);
  }

  String _getImagePath(String nombreEjercicio) {
    // Normaliza el nombre para hacer match con la imagen
    String nombre = nombreEjercicio.toLowerCase().replaceAll(' ', '_');
    return 'assets/ejercicios/$nombre.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Selecciona Ejercicios',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.pink[800],
            height: 3.0,
            margin: const EdgeInsets.only(left: 16, right: 16),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: ejerciciosTotales.length,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemBuilder: (context, index) {
          /*
          Dentro de estas funciones vamos a obtener la lista de los ejercicios
          Su seleccion y sobre todo empezar a notar si hay considencias con los
          nombres de los ejercicios y mandar a llamar a las imagenes.
           */
          final ejercicio = ejerciciosTotales[index];
          final seleccionado = estaSeleccionado(ejercicio);
          final imagen = _getImagePath(ejercicio['nombre']);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagen,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[800],
                      /*
                      Child para mostrar dentro de las tarjetas si no hay imagen para ese ejercicio
                      y mostrar un icono de no encontrado/no soportado.
                       */
                      child: const Icon(Icons.image_not_supported, color: Colors.white),
                    );
                  },
                ),
              ),
              title: Text(
                ejercicio['nombre'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Principal: ${ejercicio['musculo']} • Tipo: ${ejercicio['tipo']}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  Text(
                    'Secundarios: ${List<String>.from(ejercicio['musculosSecundarios']).join(', ')}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              trailing: Checkbox(
                value: seleccionado,
                onChanged: (valor) {
                  setState(() {
                    if (valor == true && !seleccionado) {
                      seleccionados.add(ejercicio);
                    } else {
                      seleccionados.removeWhere((e) => e['nombre'] == ejercicio['nombre']);
                    }
                  });
                },
                checkColor: Colors.black,
                activeColor: Colors.green,
                side: const BorderSide(color: Colors.green),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        onPressed: _guardarSeleccion,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text(
          'Guardar',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}




