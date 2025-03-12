import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() => _auth.currentUser;
// Sign in with email and password
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessageFromCode(
          e.code); // Convert Firebase error codes to readable messages
    } catch (e) {
      throw "An unexpected error occurred. Please try again.";
    }
  }

  Future<UserCredential> signUpWithEmailPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': name,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessageFromCode(e.code);
    } catch (e) {
      throw "An unexpected error occurred. Please try again.";
    }
  }

  Future<void> signOut() async => await _auth.signOut();

  String _getErrorMessageFromCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password should be at least 6 characters long.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
