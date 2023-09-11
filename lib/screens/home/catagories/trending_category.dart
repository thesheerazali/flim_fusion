import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_fusion/constants/routes.dart';
import 'package:film_fusion/controller/home_screen_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../../controller/favorite_screen_controller.dart';
import '../../../services/firebase_service.dart';
import '../../../utils/genre_data.dart';

class TrendingCategoriesList extends GetView<HomeScreenController> {
  final String title;

  const TrendingCategoriesList(this.title, {super.key});

  // Get the instance of HomeScreenController

  @override
  Widget build(BuildContext context) {
    final FavorieScreenController favcontroller =
        Get.find<FavorieScreenController>();
    return Obx(() {
      return WillPopScope(
          onWillPop: () async {
            controller.resetPageParameter();
            return true; // Allow the back navigation
          },
          child: Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                elevation: 0,
                title: Text(
                  title,
                  style: TextStyle(
                      fontSize: 30, color: Colors.white.withOpacity(0.8)),
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
                  itemCount: controller.trendingMovies.length +
                      1, // Add 1 for the loading indicator
                  controller: controller.scrollControllerTrending,

                  itemBuilder: (context, index) {
                    if (index < controller.trendingMovies.length) {
                      final movie = controller.trendingMovies[index];
                      final genreNames =
                          GenreData().mapGenreIdsToNames(movie.genreIds, 2);
                      return GestureDetector(
                        onTap: () =>
                            Get.offNamed(detailScreen, arguments: movie),
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
                                  child: GestureDetector(
                                    onTap: () {
                                      // favcontroller
                                      //     .toggleFavoriteStatus(movie.id);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors
                                            .grey, // Default color when the movie is not saved
                                      ),
                                      child: Icon(
                                        Icons
                                            .favorite_border, // Change the icon based on the saved status
                                        color: Colors.white, // Icon color
                                      ),
                                    ),
                                  ),
                                ),
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
                              itemBuilder: (context, _) => const Icon(
                                  Icons.star,
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
                      return controller.trendingHasMoreData.value
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                          : const SizedBox();
                    }
                  },
                ),
              )));
    });
  }
}
