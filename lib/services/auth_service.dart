import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Usuario actual
  User? get usuarioActual => _auth.currentUser;

  // Registro
  Future<User?> registrarUsuario(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      throw Exception('Error al registrar: $e');
    }
  }

  // Login
  Future<User?> iniciarSesion(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  // Logout
  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }

  // Stream de autenticación
  Stream<User?> get estadoUsuario => _auth.authStateChanges();
}
