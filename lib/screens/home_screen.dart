import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_gym_hibrido/services/rutina_service.dart';
import 'package:app_gym_hibrido/models/rutina_model.dart';
import 'package:app_gym_hibrido/screens/crear_rutina_screen.dart';
import 'package:app_gym_hibrido/widgets/rutina_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late RutinaService rutinaService;
  List<RutinaModel> rutinas = [];
  bool isLoading = true;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      rutinaService = RutinaService(userId: user!.uid);
      cargarRutinas();
    }
  }

  Future<void> cargarRutinas() async {
    try {
      final datos = await rutinaService.obtenerRutinas();
      setState(() {
        rutinas = datos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar rutinas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, ${user?.email ?? "Usuario"}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Aquí puedes redirigir al login si lo deseas
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : rutinas.isEmpty
          ? const Center(child: Text('No tienes rutinas aún.'))
          : ListView.builder(
        itemCount: rutinas.length,
        itemBuilder: (context, index) {
          return RutinaCard(rutina: rutinas[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CrearRutinaScreen(userId: user!.uid),
            ),
          );
          if (resultado == true) {
            cargarRutinas(); // Recargar rutinas si se creó una nueva
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

