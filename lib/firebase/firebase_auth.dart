import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthHelper {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> emailLogin({
    required String email,
    required String password,
  }) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
