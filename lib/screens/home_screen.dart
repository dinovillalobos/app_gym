import 'package:app_gym_hibrido/models/rutina_model.dart';
import 'package:app_gym_hibrido/models/usuario_model.dart';
import 'package:app_gym_hibrido/screens/crear_rutina_screen.dart';
import 'package:app_gym_hibrido/screens/rutina_detail_screen.dart';
import 'package:app_gym_hibrido/services/rutina_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required String title}) : super(key: key);

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
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Bienvenido, $username',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.green[900],
            height: 3.0,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : rutinas.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'No hay rutinas registradas.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Crear rutina'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CrearRutinaScreen(
                      title: '',
                      userId: '',
                    ),
                  ),
                ).then((_) => cargarDatosIniciales(userId));
              },
            ),
          ],
        ),
      )
          : Padding(
        // Posicio para poder centrar y bajar más los containers con las rutinas
        padding: const EdgeInsets.only(top: 100),
        child: ListView.builder(
          itemCount: rutinas.length,
          itemBuilder: (context, index) {
            final rutina = rutinas[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: ConstrainedBox(
                  constraints:
                  const BoxConstraints(maxWidth: 360),
                  child: InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DetalleRutinaScreen(rutina: rutina),
                        ),
                      );
                      cargarDatosIniciales(userId);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rutina.nombre,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  rutina.descripcion,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white54,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



