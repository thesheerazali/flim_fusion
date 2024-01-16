// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_fusion/utils/constants/routes.dart';

import 'package:film_fusion/utils/genre_data.dart';
import 'package:flutter/material.dart';

import 'package:film_fusion/controller/home_screen_controller.dart';
import 'package:get/get.dart';

class LatestMoviePoster extends StatelessWidget {
  LatestMoviePoster({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeScreenController controller = Get.put(HomeScreenController());
    return Flexible(
      flex: 1,
      fit: FlexFit.loose,
      child: SizedBox(
          height: 300,
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.latsetmoviesList.length,
              itemBuilder: (context, index) {
                final movie = controller.latsetmoviesList[index];
                final genreNames =
                    GenreData().mapGenreIdsToNames(movie.genreIds, 2);
                return GestureDetector(
                  onTap: () => Get.toNamed(detailScreen, arguments: movie),
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.red,
                          ),
                          child: Text(
                            genreNames,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )),
    );
  }
}
