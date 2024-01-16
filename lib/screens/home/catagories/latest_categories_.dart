import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_fusion/utils/constants/routes.dart';
import 'package:film_fusion/controller/home_screen_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../../controller/favorite_screen_controller.dart';
import '../../../utils/genre_data.dart';

class LatestCategoriesList extends StatelessWidget {
  final String title;

  LatestCategoriesList(this.title, {super.key});
  final user = FirebaseAuth.instance.currentUser;

  // Get the instance of HomeScreenController

  @override
  Widget build(BuildContext context) {
    HomeScreenController controller = Get.put(HomeScreenController());
    FavoriteMoviesController favoriteMoviesController =
        Get.put(FavoriteMoviesController());
    favoriteMoviesController.fetchFavoriteMovies(user!.uid);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: Text(
            title,
            style:
                TextStyle(fontSize: 30, color: Colors.white.withOpacity(0.8)),
          ),
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 30,
              ),
              onPressed: () {
                controller.resetPageParameter();
              }),
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 29.0, // Add spacing between rows
                  crossAxisSpacing: 20.0,
                  childAspectRatio: 0.5 // Add spacing between co
                  ),
              itemCount: controller.latsetmoviesList.length +
                  1, // Add 1 for the loading indicator
              controller: controller.scrollControllerLatest,

              itemBuilder: (context, index) {
                if (index < controller.latsetmoviesList.length) {
                  final movie = controller.latsetmoviesList[index];

                  final genreNames =
                      GenreData().mapGenreIdsToNames(movie.genreIds, 2);

                  return GestureDetector(
                    onTap: () => Get.toNamed(detailScreen, arguments: movie),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(50),
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.fill,
                                width: 147,
                                height: 217,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: Get.width * .27, top: 10),
                                child: Obx(
                                  () {
                                    final isFavorite = favoriteMoviesController
                                        .isMovieFavorite(movie);

                                    return IconButton(
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        favoriteMoviesController.toggleFavorite(
                                            movie: movie, userId: user!.uid);
                                      },
                                    );
                                  },
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          movie.title,
                          maxLines: 1, // Limit to one line
                          overflow: TextOverflow
                              .ellipsis, // Add ellipsis (...) for overflow
                          style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.red,
                          ),
                          child: Text(
                            maxLines: 1, // Limit to one line
                            overflow: TextOverflow.ellipsis,
                            genreNames,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        RatingBar.builder(
                          initialRating: movie.voteAverage /
                              2, // Divide by 2 to convert to a 5-star rating
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 15,
                          unratedColor: Colors.white.withOpacity(0.8),
                          itemBuilder: (context, _) => const Icon(Icons.star,
                              color: Color.fromRGBO(242, 163, 58, 1)),
                          onRatingUpdate: (newRating) {
                            // Handle rating updates if needed
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  // Display loading indicator when reaching the end
                  return controller.latestHasMoreData.value
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                      : const SizedBox();
                }
              },
            )));
  }
}
