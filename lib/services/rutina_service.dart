import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rutina_model.dart';

class RutinaService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId;

  RutinaService({required this.userId});

  CollectionReference get _rutinasRef =>
      _db.collection('usuarios').doc(userId).collection('rutinas');

  Future<RutinaModel> crearRutina(RutinaModel rutina) async {
    try {
      print('Guardando rutina para UID: $userId');
      print('Datos de rutina antes de guardar: ${rutina.toJson()}');

      // Generar nuevo ID
      final newDocRef = _rutinasRef.doc();

      // Crear rutina con ID y asegurar que tenga el idUsuario correcto
      final rutinaConId = rutina.copyWith(
        id: newDocRef.id,
        idUsuario: userId,
      );

      // Guardar rutina
      await newDocRef.set(rutinaConId.toJson());

      print('✅ Rutina guardada exitosamente con ID: ${newDocRef.id}');

      return rutinaConId; // ✅ retornamos la rutina con ID asignado
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
      if (rutina.id.isEmpty) {
        throw Exception('El ID de la rutina está vacío');
      }

      await _rutinasRef.doc(rutina.id).update(rutina.toJson());
    } catch (e) {
      throw Exception('Error al actualizar rutina: $e');
    }
  }
}