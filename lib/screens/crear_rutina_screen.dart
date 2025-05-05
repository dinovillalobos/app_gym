import 'package:flutter/material.dart';
import '../models/rutina_model.dart';
import 'package:app_gym_hibrido/services/rutina_service.dart';

class CrearRutinaScreen extends StatefulWidget {
  @override
  _CrearRutinaScreenState createState() => _CrearRutinaScreenState();
}

class _CrearRutinaScreenState extends State<CrearRutinaScreen> {
  late RutinaService rutinaService;

  @override
  void initState() {
    super.initState();
    rutinaService = RutinaService(userId: 'UID_DEL_USUARIO'); // Aquí deberías usar el UID real del usuario
  }

  void guardarRutina() async {
    RutinaModel nuevaRutina = RutinaModel(
      id: '',
      nombre: 'Rutina de fuerza',
      descripcion: 'Rutina para ganar fuerza y volumen',
      nivel: 'intermedio',
      tipo: 'hipertrofia',
      fechaCreacion: DateTime.now(),
    );

    await rutinaService.crearRutina(nuevaRutina);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rutina guardada con éxito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Rutina')),
      body: Center(
        child: ElevatedButton(
          onPressed: guardarRutina,
          child: Text('Guardar Rutina'),
        ),
      ),
    );
  }

}




