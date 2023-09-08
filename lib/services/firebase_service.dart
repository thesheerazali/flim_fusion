import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUpUser({
    required String email,
    required String password,
    required String name,
  
    required String phone,
    required String username,
  }) async {
    try {
      // Create a user account with email and password
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Get the current user's UID
      final currentUser = _auth.currentUser;
      final uid = currentUser?.uid;

      if (uid != null) {
        // Store user data in Firestore
        await _firestore.collection('users').doc(uid).set({
          'name': name,
        
          'phone': phone,
          'email': email,
          'username': username,
        });
      }
    } catch (e) {
      // Handle signup errors
      print('Signup Error: $e');
      throw e;
    }
  }
}
