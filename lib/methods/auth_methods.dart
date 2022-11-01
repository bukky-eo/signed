import 'package:firebase_auth/firebase_auth.dart';

import '../helpers/constants.dart';

class AuthMethods {
  Future<String?> loginUser(String email, String password) async {
    UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User? user = credential.user;
    return user?.uid;
  }

  Future<String?> signUpUser(String email, String password) async {
    try {
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return user?.uid;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User?> getCurrentUser() async {
    User user = firebaseAuth.currentUser!;
    return user;
  }

  Future<void> signOut() async {
    return firebaseAuth.signOut();
  }
}
