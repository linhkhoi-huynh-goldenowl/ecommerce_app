import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/modules/repositories/features/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    }
    return false;
  }

  @override
  Future<bool> signUp(String name, String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User? user = _firebaseAuth.currentUser;
      final _uid = user?.uid;

      FirebaseFirestore.instance.collection('users').doc(_uid).set({
        'id': _uid,
        'name': name,
        'email': email,
        'dateOfBirth': null,
        'notificationSale': false,
        'notificationNewArrivals': false,
        'notificationDelivery': false,
      });
      return true;
    } catch (_) {
      throw Exception('Error');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}
