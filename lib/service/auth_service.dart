import 'package:dartpractice/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login

  //register
  Future registerUserWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      // call our db service to update user data
      await DatabaseService(uid: user.uid).updateUserData(fullName, email);
      return true;
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }
  //signout
}
