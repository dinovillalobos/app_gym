import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_gym_hibrido/models/usuario_model.dart';

class UsuarioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Referencia a la colección de usuarios
  CollectionReference get _usuariosRef => _db.collection('usuarios');

  // Crear usuario nuevo en Firestore
  Future<void> crearUsuario(UsuarioModel usuario) async {
    try {
      await _usuariosRef.doc(usuario.uid).set(usuario.toJson());
    } catch (e) {
      throw Exception('Error al crear usuario: $e');
    }
  }

  // Obtener un usuario por ID
  Future<UsuarioModel?> obtenerUsuario(String id) async {
    try {
      final doc = await _usuariosRef.doc(id).get();
      if (doc.exists) {
        return UsuarioModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error al obtener usuario: $e');
    }
  }

  // Actualizar datos del usuario
  Future<void> actualizarUsuario(UsuarioModel usuario) async {
    try {
      await _usuariosRef.doc(usuario.uid).update(usuario.toJson());
    } catch (e) {
      throw Exception('Error al actualizar usuario: $e');
    }
  }

  // Eliminar usuario (opcional)
  Future<void> eliminarUsuario(String id) async {
    try {
      await _usuariosRef.doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar usuario: $e');
    }
  }
}
