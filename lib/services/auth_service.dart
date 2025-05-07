import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> registrarUsuario(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // Guardar información adicional en Firestore
        await _db.collection('usuarios').doc(user.uid).set({
          'email': email,
          'username': username,
          'uid': user.uid,
          'fechaRegistro': DateTime.now(),
        });
        return user;
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('Error al registrar usuario: ${e.message}');
    }

    return null;
  }

  Future<User?> iniciarSesion(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }
}
