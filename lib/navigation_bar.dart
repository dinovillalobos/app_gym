import 'package:flutter/material.dart';
import 'package:app_gym_hibrido/screens/home_screen.dart';
import 'package:app_gym_hibrido/screens/crear_rutina_screen.dart';

class navigationBar extends StatefulWidget{
  final String userId;
  const navigationBar ({super.key, required this.userId});

  @override
  State<navigationBar> createState() => _navigationBarState();
}

class _navigationBarState extends State<navigationBar>{
  int _screenAct = 0;
  late Widget _cuerpo;

  void _changeScreen(int i){
    setState(() {
      _screenAct = i;

      switch (_screenAct) {
        case 0:
          _cuerpo = HomeScreen(title: "Inicio");
        case 1:
          _cuerpo = CrearRutinaScreen(
            title: "Rutinas",
            userId: widget.userId,
          );
        default:
          _cuerpo = HomeScreen(title: "Inicio");

      }
    });
  }

  @override
  void initState(){
    super.initState();
    _cuerpo = HomeScreen(title: "Inicio");
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _cuerpo,
      bottomNavigationBar: BottomNavigationBar(
          items: const[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.sports_bar),
                label: 'Rutinas',
            ),
          ],
        backgroundColor: Colors.black,
        currentIndex: _screenAct,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        onTap: _changeScreen,
      ),
    );
  }
}
