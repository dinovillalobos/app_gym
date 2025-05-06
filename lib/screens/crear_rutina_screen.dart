import 'package:flutter/material.dart';
import 'package:app_gym_hibrido/models/rutina_model.dart';
import 'package:app_gym_hibrido/services/rutina_service.dart';

class CrearRutinaScreen extends StatefulWidget {
  final String userId;

  const CrearRutinaScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _CrearRutinaScreenState createState() => _CrearRutinaScreenState();
}

class _CrearRutinaScreenState extends State<CrearRutinaScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  String _tipo = 'híbrida';
  String _nivel = 'principiante';

  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Rutina')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre de la rutina'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              DropdownButtonFormField<String>(
                value: _tipo,
                decoration: InputDecoration(labelText: 'Tipo'),
                items: ['híbrida', 'hipertrofia', 'fuerza', 'potencia']
                    .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
                    .toList(),
                onChanged: (value) => setState(() => _tipo = value!),
              ),
              DropdownButtonFormField<String>(
                value: _nivel,
                decoration: InputDecoration(labelText: 'Nivel'),
                items: ['principiante', 'intermedio', 'avanzado']
                    .map((nivel) => DropdownMenuItem(value: nivel, child: Text(nivel)))
                    .toList(),
                onChanged: (value) => setState(() => _nivel = value!),
              ),
              SizedBox(height: 24),
              _isSaving
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _guardarRutina,
                child: Text('Guardar rutina'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _guardarRutina() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final rutina = RutinaModel(
      id: '', // Se asignará automáticamente
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      tipo: _tipo,
      nivel: _nivel,
      fechaCreacion: DateTime.now(),
    );

    final rutinaService = RutinaService(userId: widget.userId);

    try {
      await rutinaService.crearRutina(rutina);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rutina guardada')),
      );
      Navigator.pop(context); // Regresar a la pantalla anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => _isSaving = false);
  }
}
