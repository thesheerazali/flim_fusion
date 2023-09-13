// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../model/movie_by_id_model.dart';
// import '../model/new_movies_model.dart';
// import '../services/movies_data.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class FavorieScreenController extends GetxController {
//   // RxList<MovieByIdModel> favoriteMovies = <MovieByIdModel>[].obs;
//   RxBool isLoading = true.obs;

//   // RxBool isFav = false.obs;//
//   final RxSet<int> favoriteMovieIds = <int>{}.obs;
//   final RxBool isFavarit = false.obs;
//   SharedPreferences? prefs;
//   List<Latest> movies = [];

//   @override
//   void onInit() {
//     // _loadUserData();
//     _loadSharedPreferences();
//     fetchFavoriteMovies();

//     super.onInit();
//   }

//   void toggleFavoriteStatus(int movieId) {
//     for (final movie in movies) {
//       if (movie.id == movieId) {
//         movie.isFavorite = !movie.isFavorite;
//         return; // Exit the loop once the movie is found and toggled.
//       }
//     }
//   }

//   List<Latest> get favoriteMoviesNew {
//     return movies.where((movie) => movie.isFavorite).toList();
//   }

//   Future<void> _loadSharedPreferences() async {
//     prefs = await SharedPreferences.getInstance();
//     final List<int> storedIds = prefs
//             ?.getStringList('favoriteMovieIds')
//             ?.map((id) => int.parse(id))
//             .toList() ??
//         [];
//     favoriteMovieIds.addAll(storedIds);
//   }

//   Stream<List<MovieByIdModel>> fetchFavoriteMovies() async* {
//     final user = FirebaseAuth.instance.currentUser;
//     final List<MovieByIdModel> favoriteMovies = [];

//     if (user != null) {
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
//         debugPrint("assedd");
//       }
//     }
//     isLoading.value = false;
//     yield favoriteMovies;
//   }

// Future<void> addToFav(int movieId) async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     final userRef =
//         FirebaseFirestore.instance.collection('users').doc(user.uid);

//     if (favoriteMovieIds.contains(movieId)) {
//       print(movieId);

//       await userRef.update({
//         'favoriteMovies': FieldValue.arrayRemove([movieId]),
//       });
//       favoriteMovieIds.remove(movieId);
//       isFavarit(false);
//     } else {
//       await userRef.update({
//         'favoriteMovies': FieldValue.arrayUnion([movieId]),
//       });
//       favoriteMovieIds.add(movieId);
//       isFavarit(true);
//     }
//     await prefs?.setStringList('favoriteMovieIds',
//         favoriteMovieIds.map((id) => id.toString()).toList());
//   }
// }

//   Future<void> removeFromFavorites(int movieId) async {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       // Remove the movie ID from the local list
//       favoriteMovieIds.remove(movieId);

//       // Remove the movie ID from Firestore
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .update({
//         'favoriteMovies': FieldValue.arrayRemove([movieId])
//       });
//       fetchFavoriteMovies();
//     }
//   }

//   // Future<bool> checkIfFavorite(String movieIdFromApi) async {
//   //   final user = FirebaseAuth.instance.currentUser;
//   //   try {
//   //     final userDoc =
//   //         FirebaseFirestore.instance.collection('users').doc(user!.uid);
//   //     final favoritesSnapshot = await userDoc.collection('favorites').get();

//   //     // Check if the movie ID from the API exists in the user's favorites
//   //     if (favoritesSnapshot.docs
//   //         .any((doc) => doc.id.toString() == movieIdFromApi)) {
//   //       isFav.value = true;
//   //     }
//   //   } catch (e) {
//   //     print('Error checking favorite: $e');
//   //   }

//   //   return isFav.value;
//   // }

// //   Stream<List<MovieByIdModel>> fetchFavoriteMovies() async*{
// //   final user = FirebaseAuth.instance.currentUser;
// //      if (user != null) {
// //       final userDoc = await FirebaseFirestore.instance
// //           .collection('users')
// //           .doc(user.uid)
// //           .get();

// //       final favoriteMovieIds =
// //           List<int>.from(userDoc.get('favoriteMovies') ?? []);

// //       // Fetch details for each favorite movie using your API
// //       for (final movieId in favoriteMovieIds) {
// //         final movie = await MovieService.fetchMovieById(movieId);
// //         favoriteMovies.add(movie);
// //       }
// //     } else {
// //     yield* Stream.value(<int>[].cast<MovieByIdModel>()); // Return an empty stream if user is not logged in
// //   }
// // }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_fusion/model/new_movies_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class FavoriteMoviesController extends GetxController {
  final RxList<Movies> favoriteMovies = <Movies>[].obs;
  final RxBool isLoading = false.obs; // Add isLoading variable

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  // Method to toggle a movie's favorite status in Firestore
  Future<void> toggleFavorite(
      {required Movies movie, required String userId}) async {
    final userDoc = _firestore.collection('users').doc(userId);
    final movieDoc = userDoc.collection('favorites').doc(movie.id.toString());

   final isFavorite = favoriteMovies.any((favoriteMovie) => favoriteMovie.id == movie.id);

    if (isFavorite) {
      // Remove from favorites
      await movieDoc.delete();
    favoriteMovies.removeWhere((favoriteMovie) => favoriteMovie.id == movie.id);
      // Get.snackbar('Removed from Favorites', movie.title,
      //     snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    } else {
      // Add to favorites
      await movieDoc.set({
        'id': movie.id,
        'title': movie.title,
        'poster_path': movie.posterPath,
        'voteAverage': movie.voteAverage
      });
      favoriteMovies.add(movie);
      // Get.snackbar('Added to Favorites', movie.title,
      //     snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.green);
    }

    // Toggle the isFavorite property
  
  }

  bool isMovieFavorite(Movies movie) {
    return favoriteMovies.any((favoriteMovie) => favoriteMovie.id == movie.id);
  }

  //Method to fetch user's favorite movies from Firestore
  Future<void> fetchFavoriteMovies(String userId) async {
     isLoading.value = true;
    final userDoc = _firestore.collection('users').doc(userId);
    final querySnapshot = await userDoc.collection('favorites').get();

    final movies = querySnapshot.docs.map((doc) {
      final data = doc.data();
      DateTime parseDate(dynamic date) {
        if (date is Timestamp) {
          return date.toDate();
        }
        return DateTime
            .now(); // Provide a default value if the date is missing or in an unexpected format.
      }

      return Movies(
        id: data['id'] ?? 0, // Provide a default value if 'id' is missing.
        title: data['title'] ??
            'Unknown', // Provide a default value if 'title' is missing.
        posterPath:
            data['poster_path'] != null ? data['poster_path'] as String : '',
        genreIds: List<int>.from(data['genreIds'] ?? []),
        overview: data['overview'] ?? '',
        releaseDate: parseDate(data['release_date']),
        voteAverage: data['voteAverage']?.toDouble() ?? 0.0,
        isFavorite: true,
      );
    }).toList();

    favoriteMovies.assignAll(movies);
     isLoading.value = false;
  }

  // Future<void> fetchFavoriteMovies(String userId) async {
  //   final userDoc = _firestore.collection('users').doc(userId);

  //   // Get the user's favorite movies data
  //   final userFavoritesDoc =
  //       await userDoc.collection('favorites').doc('user_favorites').get();

  //   if (userFavoritesDoc.exists) {
  //     final userFavoritesData = userFavoritesDoc.data() as Map<String, dynamic>;
  //     DateTime parseDate(dynamic date) {
  //       if (date is Timestamp) {
  //         return date.toDate();
  //       }
  //       return DateTime
  //           .now(); // Provide a default value if the date is missing or in an unexpected format.
  //     }

  //     final movies = userFavoritesData.values.map((data) {
  //       return Movies(
  //         id: data['id'] ?? 0, // Provide a default value if 'id' is missing.
  //         title: data['title'] ??
  //             'Unknown', // Provide a default value if 'title' is missing.
  //         posterPath:
  //             data['poster_path'] != null ? data['poster_path'] as String : '',
  //         genreIds: List<int>.from(data['genreIds'] ?? []),
  //         overview: data['overview'] ?? '',
  //         releaseDate: parseDate(data['release_date']),
  //         voteAverage: data['voteAverage']?.toDouble() ?? 0.0,
  //         isFavorite: true,
  //       );
  //     }).toList();

  //     favoriteMovies.assignAll(movies);
  //   } else {
  //     favoriteMovies.clear();
  //   }
  // }
}
