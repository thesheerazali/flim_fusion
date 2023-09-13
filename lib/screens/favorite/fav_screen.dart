import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_fusion/controller/favorite_screen_controller.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:get/get.dart';
// // Replace with your controller

class FavScreen extends StatelessWidget {
  FavScreen({super.key});

  FavoriteMoviesController controller = Get.put(FavoriteMoviesController());
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    controller.fetchFavoriteMovies(user!.uid);
    // controller.fetchFavoriteMovies();
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Favorites',
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          final favoriteMovies = controller.favoriteMovies;

          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (favoriteMovies.isEmpty) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: Get.width * .006,
                  ),
                  const Text("NO FAVORITE ITEM AVAILBLE")
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                print(favoriteMovies.length);
                return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl:
                          'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.fill,
                      width: 80,
                    ),
                    title: Text(movie.title),
                    subtitle: RatingBar.builder(
                      initialRating: movie.voteAverage /
                          2, // Divide by 2 to convert to a 5-star rating
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 15,
                      unratedColor: Colors.grey,
                      itemBuilder: (context, _) => const Icon(Icons.star,
                          color: Color.fromRGBO(242, 163, 58, 1)),
                      onRatingUpdate: (newRating) {
                        // Handle rating updates if needed
                      },
                    ),
                    trailing:
                        // final isFavorite = controller.movies[index].isFavorite;
                        IconButton(
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        controller.toggleFavorite(
                            movie: movie, userId: user!.uid);
                      },
                    ));
              },
            );
          }
        }));
  }
}
// StreamBuilder<List<MovieByIdModel>>(
//           stream: controller.fetchFavoriteMovies(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return const Text('Error');
//             } else if (snapshot.hasData) {
//               return ListView.builder(
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final movie = snapshot.data![index];
                  // return ListTile(
                  //   leading: CachedNetworkImage(
                  //     imageUrl:
                  //         'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                  //     placeholder: (context, url) =>
                  //         const CircularProgressIndicator(),
                  //     errorWidget: (context, url, error) =>
                  //         const Icon(Icons.error),
                  //     fit: BoxFit.fill,
                  //     width: 80,
                  //   ),
                  //   title: Text(movie.title),
                  //   subtitle: RatingBar.builder(
                  //     initialRating: movie.voteAverage /
                  //         2, // Divide by 2 to convert to a 5-star rating
                  //     minRating: 1,
                  //     direction: Axis.horizontal,
                  //     allowHalfRating: true,
                  //     itemCount: 5,
                  //     itemSize: 15,
                  //     unratedColor: Colors.grey,
                  //     itemBuilder: (context, _) => const Icon(Icons.star,
                  //         color: Color.fromRGBO(242, 163, 58, 1)),
                  //     onRatingUpdate: (newRating) {
                  //       // Handle rating updates if needed
                  //     },
                  //   ),
                  //   trailing: IconButton(
                  //     icon: const Icon(Icons.delete),
                  //     onPressed: () {
                  //       // Remove the movie from favorites
                  //       controller.removeFromFavorites(movie.id);
                  //     },
                  //   ),
                  // );
//                 },
//               );
//             } else {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         )


// class FavScreen extends GetView<FavorieScreenController> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Favorites'),
//       ),
//       body: Obx(() {
//         if (controller.favoriteMovies.isEmpty) {
//           return const Center(
//             child: Text('You have no favorite movies yet.'),
//           );
//         } else {
//           return NotificationListener<ScrollNotification>(
//             onNotification: (ScrollNotification scrollInfo) {
//               if (scrollInfo is ScrollEndNotification &&
//                   scrollInfo.metrics.pixels ==
//                       scrollInfo.metrics.maxScrollExtent) {
//                 // User reached the end of the list, load more data here
//                 controller.fetchFavoriteMovies();
//               }
//               return false;
//             },
//             child: ListView.builder(
//               itemCount: controller.favoriteMovies.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final movie = controller.favoriteMovies[index];
//                 return ListTile(
//                       leading: CachedNetworkImage(
//                         imageUrl:
//                             'https://image.tmdb.org/t/p/w200${movie.posterPath}',
//                         placeholder: (context, url) =>
//                             const CircularProgressIndicator(),
//                         errorWidget: (context, url, error) =>
//                             const Icon(Icons.error),
//                         fit: BoxFit.fill,
//                         width: 80,
//                       ),
//                       title: Text(movie.title),
//                       subtitle: RatingBar.builder(
//                         initialRating: movie.voteAverage /
//                             2, // Divide by 2 to convert to a 5-star rating
//                         minRating: 1,
//                         direction: Axis.horizontal,
//                         allowHalfRating: true,
//                         itemCount: 5,
//                         itemSize: 15,
//                         unratedColor: Colors.white.withOpacity(0.8),
//                         itemBuilder: (context, _) => const Icon(Icons.star,
//                             color: Color.fromRGBO(242, 163, 58, 1)),
//                         onRatingUpdate: (newRating) {
//                           // Handle rating updates if needed
//                         },
//                       ),
//                       trailing: IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () {
//                           // Remove the movie from favorites
//                           controller.removeFromFavorites(movie.id);
//                         },
//                       ),
//                     );
//               },
//             ),
//           );
//         }
//       }),
//     );
//   }
// }
