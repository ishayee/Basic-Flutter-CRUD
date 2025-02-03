import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register user
  Future<User?> registerUser(String email, String password, name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Error in register: ${e.message}");
      throw e; // Throw the error instead of returning null
    }
  }

  // Login user
  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Error in login: ${e.message}");
      throw e; // Throw the error so it can be caught in LoginPage
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
