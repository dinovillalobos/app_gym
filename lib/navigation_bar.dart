import 'package:app_gym_hibrido/screens/home_screen.dart';
import 'package:app_gym_hibrido/screens/crear_rutina_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class navigationBar extends StatefulWidget {
  final String userId;
  const navigationBar({super.key, required this.userId});

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
          _cuerpo = HomeScreen(title: "Inicio");
          break;
        case 1:
          _cuerpo = CrearRutinaScreen(
            title: "Rutinas",
            userId: widget.userId,
          );
          break;
        default:
          _cuerpo = HomeScreen(title: "Inicio");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _cuerpo = HomeScreen(title: "Inicio");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // <-- Esto permite que el cuerpo se extienda detrás de la nav bar
      backgroundColor: Colors.transparent,
      body: _cuerpo,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  activeIcon: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.home, color: Colors.white),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.dumbbell),
                  activeIcon: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: FaIcon(FontAwesomeIcons.dumbbell, color: Colors.white),
                  ),
                  label: '',
                ),
              ],
              backgroundColor: Colors.black,
              currentIndex: _screenAct,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: _changeScreen,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }

}

