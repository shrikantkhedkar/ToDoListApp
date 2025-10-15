import 'package:firebase_auth/firebase_auth.dart';
import 'package:rbricks_test/model/userModel.dart';
//import 'package/models/user_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> signUp(UserModel user) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> login(UserModel user) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
