import 'package:app_gym_hibrido/models/rutina_model.dart';
import 'package:app_gym_hibrido/models/usuario_model.dart';
import 'package:app_gym_hibrido/screens/crear_rutina_screen.dart';
import 'package:app_gym_hibrido/screens/rutina_detail_screen.dart';
import 'package:app_gym_hibrido/services/rutina_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late RutinaService rutinaService;
  List<RutinaModel> rutinas = [];
  String username = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    rutinaService = RutinaService(userId: userId);
    cargarDatosIniciales(userId);
  }

  Future<void> cargarDatosIniciales(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        final usuario = UsuarioModel.fromJson(userDoc.data()!, userId);
        final rutinasData = await rutinaService.obtenerRutinas();

        setState(() {
          username = usuario.username;
          rutinas = rutinasData;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error al cargar datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, $username'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : rutinas.isEmpty
          ? const Center(child: Text('No hay rutinas registradas.'))
          : ListView.builder(
        itemCount: rutinas.length,
        itemBuilder: (context, index) {
          final rutina = rutinas[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(rutina.nombre),
              subtitle: Text(rutina.descripcion),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetalleRutinaScreen(
                      rutina: rutina,
                      userId:
                      FirebaseAuth.instance.currentUser!.uid,
                    ),
                  ),
                );
                // Refrescar después de volver de detalles
                cargarDatosIniciales(
                    FirebaseAuth.instance.currentUser!.uid);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final userId = FirebaseAuth.instance.currentUser!.uid;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CrearRutinaScreen(userId: userId),
            ),
          ).then((_) => cargarDatosIniciales(userId)); // Refrescar al volver
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

