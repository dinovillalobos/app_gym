import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rutina_model.dart';

class RutinaService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId;

  RutinaService({required this.userId});

  CollectionReference get _rutinasRef =>
      _db.collection('usuarios').doc(userId).collection('rutinas');

  Future<void> crearRutina(RutinaModel rutina) async {
    try {
      print('Guardando rutina para UID: $userId');
      print('Datos de rutina: ${rutina.toJson()}');

      await _rutinasRef.doc(rutina.id).set(rutina.toJson());

      print('✅ Rutina guardada exitosamente.');
    } catch (e) {
      print('❌ Error al guardar rutina: $e');
      throw Exception('Error al guardar rutina: $e');
    }
  }

  Future<List<RutinaModel>> obtenerRutinas() async {
    try {
      final snapshot = await _rutinasRef.get();
      return snapshot.docs.map((doc) {
        return RutinaModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener rutinas: $e');
    }
  }

  Future<void> eliminarRutina(String rutinaId) async {
    try {
      await _rutinasRef.doc(rutinaId).delete();
    } catch (e) {
      throw Exception('Error al eliminar rutina: $e');
    }
  }

  Future<void> actualizarRutina(RutinaModel rutina) async {
    try {
      await _rutinasRef.doc(rutina.id).update(rutina.toJson());
    } catch (e) {
      throw Exception('Error al actualizar rutina: $e');
    }
  }
}
