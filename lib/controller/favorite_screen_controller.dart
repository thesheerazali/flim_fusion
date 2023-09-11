import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/movie_by_id_model.dart';
import '../services/movies_data.dart';

class FavorieScreenController extends GetxController {
  // RxList<MovieByIdModel> favoriteMovies = <MovieByIdModel>[].obs;
  // RxBool isLoading = true.obs;

  // RxBool isFav = false.obs;
  // final RxSet<int> favoriteMovieIds = <int>{}.obs;

  // @override
  // void onInit() {
  //   // _loadUserData();

  //   super.onInit();
  // }

  // Future<void> fetchFavoriteMovies() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     final userDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .get();

  //     final favoriteMovieIds =
  //         List<int>.from(userDoc.get('favoriteMovies') ?? []);

  //     // Fetch details for each favorite movie using your API
  //     for (final movieId in favoriteMovieIds) {
  //       final movie = await MovieService.fetchMovieById(movieId);
  //       favoriteMovies.add(movie);
  //       debugPrint("assedd");
  //     }
  //   }
  //   isLoading.value = false;
  // }

  // Future<void> removeFromFavorites(int movieId) async {
  //   final user = FirebaseAuth.instance.currentUser;

  //   if (user != null) {
  //     // Remove the movie ID from the local list
  //     favoriteMovies
  //         .removeWhere((movie) => movie.id.toString() == movieId.toString());

  //     // Remove the movie ID from Firestore
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .update({
  //       'favoriteMovies': FieldValue.arrayRemove([movieId])
  //     });
  //   }
  // }

  // Future<void> toggleFavoriteStatus(int movieId) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     final userRef =
  //         FirebaseFirestore.instance.collection('users').doc(user.uid);

  //     if (favoriteMovieIds.contains(movieId)) {
  //       await userRef.update({
  //         'favoriteMovies': FieldValue.arrayRemove([movieId]),
  //       });
  //       favoriteMovieIds.remove(movieId);
  //     } else {
  //       await userRef.update({
  //         'favoriteMovies': FieldValue.arrayUnion([movieId]),
  //       });
  //       favoriteMovieIds.add(movieId);
  //     }
  //   }
  // }

  // Future<bool> checkIfFavorite(String movieIdFromApi) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   try {
  //     final userDoc =
  //         FirebaseFirestore.instance.collection('users').doc(user!.uid);
  //     final favoritesSnapshot = await userDoc.collection('favorites').get();

  //     // Check if the movie ID from the API exists in the user's favorites
  //     if (favoritesSnapshot.docs
  //         .any((doc) => doc.id.toString() == movieIdFromApi)) {
  //       isFav.value = true;
  //     }
  //   } catch (e) {
  //     print('Error checking favorite: $e');
  //   }

  //   return isFav.value;
  // }

//   Stream<List<MovieByIdModel>> fetchFavoriteMovies() async*{
//   final user = FirebaseAuth.instance.currentUser;
//      if (user != null) {
//       final userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();

//       final favoriteMovieIds =
//           List<int>.from(userDoc.get('favoriteMovies') ?? []);

//       // Fetch details for each favorite movie using your API
//       for (final movieId in favoriteMovieIds) {
//         final movie = await MovieService.fetchMovieById(movieId);
//         favoriteMovies.add(movie);
//       }
//     } else {
//     yield* Stream.value(<int>[].cast<MovieByIdModel>()); // Return an empty stream if user is not logged in
//   }
// }
}
