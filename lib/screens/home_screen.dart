import 'package:flutter/material.dart';
import 'crear_rutina_screen.dart'; // 👈 Importa tu pantalla

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CrearRutinaScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Bienvenido a tu app de rutinas 🚀'),
      ),
    );
  }
}
