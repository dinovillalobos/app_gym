import 'package:flutter/material.dart';
import 'package:app_gym_hibrido/screens/home_screen.dart';
import 'package:app_gym_hibrido/screens/crear_rutina_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class navigationBar extends StatefulWidget {
  const navigationBar({super.key});

  @override
  State<navigationBar> createState() => _navigationBarState();
}

class _navigationBarState extends State<navigationBar> {
  int _screenAct = 0;
  late Widget _cuerpo;

  void _changeScreen(int i) {
    setState(() {
      _screenAct = i;

      switch (_screenAct) {
        case 0:
          _cuerpo = const HomeScreen();
          break;
        case 1:
          _cuerpo = const CrearRutinaScreen();
          break;
        default:
          _cuerpo = const HomeScreen();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _cuerpo = const HomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: _cuerpo,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
              BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Rutinas'),
            ],
            backgroundColor: Colors.black54,
            currentIndex: _screenAct,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.white70,
            onTap: _changeScreen,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
