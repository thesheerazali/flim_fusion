import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 // Getter for isSaved

  Future<void> signUpUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String username,
  }) async {
    try {
      // Create a user account with email and password
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

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

 
 
// Future<void> saveMovieToFirestore(int movieId) async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     final userDoc =
//         FirebaseFirestore.instance.collection('users').doc(user.uid);
//     final currentFavorites = await userDoc.get().then((doc) {
//       if (doc.exists) {
//         return List<int>.from(doc['favoriteMovies'] ?? []);
//       } else {
//         return [];
//       }
//     });
//     currentFavorites.add(movieId);
//     await userDoc.set({'favoriteMovies': currentFavorites});
//   }
// }
}
