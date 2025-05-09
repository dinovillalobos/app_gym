import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/rutina_model.dart';
import '../services/rutina_service.dart';
import 'rutina_detail_screen.dart';

class MisRutinasScreen extends StatefulWidget {
  const MisRutinasScreen({Key? key}) : super(key: key);

  @override
  State<MisRutinasScreen> createState() => _MisRutinasScreenState();
}

class _MisRutinasScreenState extends State<MisRutinasScreen> {
  List<RutinaModel> rutinas = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarRutinas();
  }

  Future<void> _cargarRutinas() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario no autenticado')),
      );
      return;
    }

    try {
      final rutinaService = RutinaService(userId: user.uid);
      final resultado = await rutinaService.obtenerRutinas();
      setState(() {
        rutinas = resultado;
        cargando = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar rutinas: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Rutinas')),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : rutinas.isEmpty
          ? const Center(child: Text('No hay rutinas guardadas.'))
          : ListView.builder(
        itemCount: rutinas.length,
        itemBuilder: (context, index) {
          final rutina = rutinas[index];
          return ListTile(
            title: Text(rutina.nombre),
            subtitle: Text(rutina.descripcion),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetalleRutinaScreen(rutina: rutina),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
