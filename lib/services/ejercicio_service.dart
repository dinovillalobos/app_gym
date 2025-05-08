import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_gym_hibrido/models/ejercicio_model.dart';

class EjercicioService {
  final String userId;
  final String rutinaId;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  EjercicioService({required this.userId, required this.rutinaId});

  CollectionReference get _ejerciciosRef => _db
      .collection('usuarios')
      .doc(userId)
      .collection('rutinas')
      .doc(rutinaId)
      .collection('ejercicios');

  Future<void> agregarEjercicio(EjercicioModel ejercicio) async {
    await _ejerciciosRef.add(ejercicio.toJson());
  }

  Future<List<EjercicioModel>> obtenerEjercicios() async {
    final snapshot = await _ejerciciosRef.get();
    return snapshot.docs.map((doc) {
      return EjercicioModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> eliminarEjercicio(String id) async {
    await _ejerciciosRef.doc(id).delete();
  }
}
